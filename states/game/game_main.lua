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

  self.musicManager = MusicManager:new()
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

    self.current = Tetromino:new(randomShapeType(), SIZE, 4 * SIZE, -SIZE * 3)
    self.current:gotoState('Falling')
  else
    self.current:update(dt)
  end

  -- if self.current.y > self.camera_y then
  --   self.camera_y = self.camera_y + dt * SIZE * 2
  -- end

  for id,creature in pairs(self.creatures) do
    creature:update(dt)
  end

  self.musicManager:update(self.set_pieces)
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

  for x, y, node in self.grid:each() do
    x = x - 1
    y = y - 1 - 2
    g.rectangle('line', x * D, y * D, D, D)
    -- g.print(node.index, x * D, y * D)
  end

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

  g.print('Fossils: ' .. #self.fossils)
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  if self.current.keypressed then
    self.current:keypressed(key, scancode, isrepeat)
  end
  -- self.current.orientation = self.current.orientation + math.pi / 2
  -- for i,v in ipairs(shapes) do
  --   v.orientation = (v.orientation + math.pi / 2) % (math.pi * 2)
  -- end
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
