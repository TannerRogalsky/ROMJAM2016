local Main = Game:addState('Main')

-- local shape_types = {'I', 'O', 'T', 'S', 'Z', 'J', 'L'}
local shape_types = {'I', 'O', 'T', 'S', 'J', 'L'}

local function randomShapeType()
  return shape_types[love.math.random(#shape_types)]
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  HC = require('lib.HardonCollider')

  self.grid = Grid:new(10, 48)
  SIZE = g.getHeight() / (self.grid.height - 2)

  do
    local i = 1
    for x, y, node in self.grid:each() do
      self.grid:set(x, y, {
        index = i
      })
      i = i + 1
    end
  end

  self.current = Tetromino:new(randomShapeType(), SIZE, 4 * SIZE, -SIZE * 2)
  self.current:gotoState('Falling')

  self.next = Tetromino:new(randomShapeType(), SIZE, 4 * SIZE, -SIZE * 2)

  self.left_bound = HC.rectangle(-SIZE - 1, 0, SIZE, g.getHeight())
  self.right_bound = HC.rectangle(SIZE * self.grid.width + 1, 0, SIZE, g.getHeight())
  self.floor = HC.rectangle(0, g.getHeight(), self.grid.width * SIZE, SIZE)
  self.top = HC.rectangle(0, 0, self.grid.width * SIZE, SIZE)

  self.set_pieces = {}

  self.creatures = {}
  self.fossils = {}

  self.camera_y = 0

  for i=1,5 do
    self:spawnSwimmingCreature()
  end
  self:spawnPlantCreature()

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:spawnSwimmingCreature()
  local start_col = love.math.random(self.grid.height - 5) + 5
  local creature = SwimmingCreature:new(self.grid.width / 2 * SIZE, start_col * SIZE, SIZE * 2, SIZE)
  self.creatures[creature.id] = creature
end

function Main:spawnPlantCreature()
  local x, y = PlantCreature.findSpawnLocation(SIZE, self.grid, self.set_pieces)
  local creature = PlantCreature:new(x, y, SIZE, SIZE)
  self.creatures[creature.id] = creature
end

function Main:update(dt)
  if self.current.set then
    table.insert(self.set_pieces, self.current)

    if self.current.polygon:collidesWith(self.top) then
      self:gotoState('Over')
    end

    self.current = self.next
    self.current:gotoState('Falling')

    self.next = Tetromino:new(randomShapeType(), SIZE, 4 * SIZE, -SIZE * 2)
  else
    self.current:update(dt)
  end

  -- if self.current.y > self.camera_y then
  --   self.camera_y = self.camera_y + dt * SIZE * 2
  -- end

  for id,creature in pairs(self.creatures) do
    creature:update(dt)
  end

  game.musicManager:update(self.set_pieces)
end

function Main:draw()
  self.camera:set()

  local D = SIZE
  local SCALE = (self.grid.height - 2) / 20
  g.push('all')
  do
    self.camera_y = math.max(0, math.min(self.current.y, (self.grid.height - 2) * SIZE - g.getHeight() / SCALE))
    g.translate(g.getWidth() / 2 - D * self.grid.width / 2 * SCALE, -self.camera_y * SCALE)
  end
  g.scale(SCALE, SCALE)
  g.setLineWidth(1 / SCALE)

  do
    -- local bg = game.preloaded_images['bg.png']
    -- g.draw(bg, 0, -SIZE * 2, 0, (self.grid.width * SIZE) / bg:getWidth())
    local bg = game.preloaded_images['bg_wide.png']
    g.draw(bg, -g.getWidth() / SCALE / 2 + SIZE * self.grid.width / 2, -SIZE * 2, 0, (g.getWidth() / SCALE) / bg:getWidth())
  end

  g.push('all')
  g.setColor(255, 255, 255, 255 * 0.3)
  for x, y, node in self.grid:each() do
    x = x - 1
    y = y - 1 - 2
    g.rectangle('line', x * D, y * D, D, D)
    -- g.print(node.index, x * D, y * D)
  end
  g.pop()

  for i,tetromino in ipairs(self.set_pieces) do
    tetromino:draw()
  end

  self.current:draw()

  for id,creature in pairs(self.creatures) do
    creature:draw()
  end

  if game.debug then
    self.floor:draw()
    self.left_bound:draw()
    self.right_bound:draw()
  end

  g.pop()

  self.camera:unset()

  local w = g.getWidth() / 8
  g.setColor(0, 0, 0, 125)
  g.rectangle('fill', 0, 0, w, self.grid.height * SIZE)
  g.setColor(255, 255, 255)
  g.print('Fossils: ' .. #self.fossils, 5, 5)
  local h = 5 + 20
  for i,creature in ipairs(self.fossils) do
    local iw, ih = creature.dead_image:getDimensions()
    local sx, sy = creature.w / iw, creature.h / ih
    g.draw(creature.dead_image, 5, h, 0, sx, sy)
    h = h + creature.h
  end

  do
    local w = g.getWidth() / 4
    local x = w * 3
    local y = 5
    g.setColor(0, 0, 0, 125)
    g.rectangle('fill', x, 0, w, self.grid.height * SIZE)
    g.setColor(255, 255, 255)
    g.print('Next:', x + w / 2, y)
    g.draw(self.next.image, x, y)
  end
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  if self.current.keypressed then
    self.current:keypressed(key, scancode, isrepeat)
  end

  if key == 'escape' then
    self:gotoState('Over')
  end
end

function Main:keyreleased(key, scancode)
  if self.current.keyreleased then
    self.current:keyreleased(key, scancode)
  end
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
