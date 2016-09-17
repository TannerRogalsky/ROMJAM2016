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

  self.grid = Grid:new(10, 60)
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

  self.set_pieces = {}

  self.creatures = {}
  self.fossils = {}

  for i=1,1 do
    local creature = SwimmingCreature:new(-SIZE * i * love.math.random(), i * SIZE * 10, SIZE * 2, SIZE)
    self.creatures[creature.id] = creature
  end

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:update(dt)
  Music.static.update()

  if self.current.set then
    table.insert(self.set_pieces, self.current)

    self.current = Tetromino:new(randomShapeType(), SIZE, 4 * SIZE, -SIZE * 2)
    self.current:gotoState('Falling')
  else
    self.current:update(dt)
  end

  for id,creature in pairs(self.creatures) do
    creature:update(dt)
  end
end

function Main:draw()
  self.camera:set()

  local D = SIZE
  local SCALE = 3
  g.push()
  do
    local y = math.max(0, math.min(self.current.y, (self.grid.height - 2) * SIZE - g.getHeight() / SCALE))
    g.translate(g.getWidth() / 2 - D * self.grid.width / 2 * SCALE, -y * SCALE)
  end
  g.scale(SCALE, SCALE)
  do
    local bg = game.preloaded_images['bg.png']
    g.draw(bg, 0, -SIZE * 2, 0, (self.grid.width * SIZE) / bg:getWidth())
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

  self.floor:draw()
  self.left_bound:draw()
  self.right_bound:draw()

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
