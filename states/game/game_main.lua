local Main = Game:addState('Main')
local renderTetromino = require('shared.render_tetromino')
local hsl2rgb = require('shared.hsl')

local PERIODS = {
  'Cambrian',
  'Ordovician',
  'Silurian',
  'Devonian',
  'Carboniferous',
  'Permian',
}

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
  SCALE = (self.grid.height - 2) / 20 -- always only shows the standard 20 tiles on screen
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
  local creature = SwimmingCreature:new(self.grid.width / 2 * SIZE, start_col * SIZE, SIZE)
  self.creatures[creature.id] = creature
end

function Main:spawnPlantCreature()
  local x, y = PlantCreature.findSpawnLocation(SIZE, self.grid, self.set_pieces)
  local creature = PlantCreature:new(x, y, SIZE, SIZE)
  self.creatures[creature.id] = creature
end

function Main:update(dt)
  -- falling tetromino
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

  -- camera
  if self.camera_y < self.current.y then
    local new_camera_y = self.camera_y + self.current.speed * dt
    local SCALE = (self.grid.height - 2) / 20
    local well_height = (self.grid.height - 2) * SIZE - g.getHeight() / SCALE
    self.camera_y = math.max(0, math.min(new_camera_y, well_height))
  else
    local new_camera_y = self.camera_y - SIZE * 50 * dt
    self.camera_y = math.max(0, new_camera_y)
  end

  for id,creature in pairs(self.creatures) do
    creature:update(dt)
  end

  game.musicManager:update(self.set_pieces)
end

function Main:draw()
  self.camera:set()

  local D = SIZE
  g.push('all')
  do
    g.translate(g.getWidth() / 2 - D * self.grid.width / 2 * SCALE, -self.camera_y * SCALE)
  end
  g.scale(SCALE, SCALE)
  g.setLineWidth(1 / SCALE)

  do
    local bg = game.preloaded_images['bg_wide.png']
    g.draw(bg, -g.getWidth() / SCALE / 2 + SIZE * self.grid.width / 2, -SIZE * 2, 0, (g.getWidth() / SCALE) / bg:getWidth())
  end

  g.push('all')
  g.setColor(255, 255, 255, 255 * 0.3)
  for x, y, node in self.grid:each() do
    x = x - 1
    y = y - 1 - 2
    g.rectangle('line', x * D, y * D, D, D)
  end
  g.pop()

  for i,tetromino in ipairs(self.set_pieces) do
    tetromino:draw()
  end

  self.current:draw()

  do
    g.push('all')
    local x = self.grid.width * SIZE
    local y = 0
    local well_height = (self.grid.height - 2) * SIZE
    local height_interval = well_height / #PERIODS
    for i,period in ipairs(PERIODS) do
      local red, green, blue = hsl2rgb(i / #PERIODS, 1, 0.5)
      g.setColor(red, green, blue, 255 * 0.5)
      g.rectangle('fill', x, y, SIZE, height_interval)
      g.setColor(255, 255, 255, 255)
      g.print(period, x, y + height_interval / 2)
      y = y + height_interval
    end
    g.pop()
  end

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

  g.push('all')
  do
    local w = g.getWidth() / 4
    local x = w * 3
    local y = 5
    g.setColor(0, 0, 0, 125)
    g.rectangle('fill', x, 0, w, self.grid.height * SIZE)
    g.setColor(255, 255, 255)
    x = x + w / 2
    g.print('Next:', x, y)
    g.scale(SCALE, SCALE)
    local iw, ih = self.next.image:getDimensions()
    renderTetromino(self.next, g.getWidth() / SCALE - iw / 2 / SCALE, ih / 2 / SCALE)
  end
  g.pop()
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
