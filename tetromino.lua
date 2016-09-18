local Tetromino = class('Tetromino', Base):include(Stateful)

local function gridify(data)
  local grid = Grid:new(#data, #data[1])
  for i,row in ipairs(data) do
    for j,col in ipairs(row) do
      grid:set(j, i, col)
    end
  end
  return grid
end

local function polygonify(data, size)
  local polygon = {}
  for i=1,#data,2 do
    local x, y = data[i], data[i + 1]
    table.insert(polygon, x * size)
    table.insert(polygon, y * size)
  end
  return polygon
end

local function collidesWithAny(tetromino, tetrominos)
  for i,other in ipairs(tetrominos) do
    if tetromino.polygon:collidesWith(other.polygon) then
      return true
    end
  end
  return false
end

local types = {
  I = {
    grid = {
      {false, false, false, false, false},
      {false, false, false, false, false},
      {true, true, true, true, false},
      {false, false, false, false, false},
      {false, false, false, false, false},
    },
    polygon = {
      0, 2,
      4, 2,
      4, 3,
      0, 3,
    },
  },
  O = {
    grid = {
      {false, false, false, false},
      {false, true, true, false},
      {false, true, true, false},
      {false, false, false, false},
    },
    polygon = {
      1, 1,
      3, 1,
      3, 3,
      1, 3,
    },
  },
  T = {
    grid = {
      {false, false, false, false, false},
      {false, false, false, false, false},
      {false, true, true, true, false},
      {false, false, true, false, false},
      {false, false, false, false, false},
    },
    polygon = {
      1, 2,
      4, 2,
      4, 3,
      3, 3,
      3, 4,
      2, 4,
      2, 3,
      1, 3,
    },
  },
  S = {
    grid = {
      {false, false, false, false},
      {false, true, true, false},
      {true, true, false, false},
      {false, false, false, false},
    },
    polygon = {
      0, 2,
      1, 2,
      1, 1,
      3, 1,
      3, 2,
      2, 2,
      2, 3,
      0, 3,
    },
  },
  Z = {
    grid = {
      {false, false, false, false},
      {true, true, false, false},
      {false, true, true, false},
      {false, false, false, false},
    },
    polygon = {
      2, 2,
      3, 2,
      3, 3,
      1, 3,
      1, 2,
      0, 2,
      0, 1,
      2, 1
    },
  },
  J = {
    grid = {
      {false, false, false, false, false},
      {false, false, true, false, false},
      {false, false, true, false, false},
      {false, true, true, false, false},
      {false, false, false, false, false},
    },
    polygon = {
      2, 1,
      3, 1,
      3, 4,
      1, 4,
      1, 3,
      2, 3,
    },
  },
  L = {
    grid = {
      {false, false, false, false, false},
      {false, false, true, false, false},
      {false, false, true, false, false},
      {false, false, true, true, false},
      {false, false, false, false, false},
    },
    polygon = {
      2, 1,
      2, 4,
      4, 4,
      4, 3,
      3, 3,
      3, 1,
    },
  },
}

local typeof = type

function Tetromino:initialize(type, size, x, y)
  Base.initialize(self)
  assert(types[type])
  assert(typeof(size) == 'number')

  self.type = type
  self.size = size
  self.orientation = 0
  self.grid = gridify(types[self.type].grid)
  -- print(self.type)
  -- print(unpack(polygonify(types[self.type].polygon, size)))
  self.polygon = HC.polygon(unpack(polygonify(types[self.type].polygon, size)))
  self.polygon:scale(0.9)
  self.polygon:move(x, y)

  self.image = game.preloaded_images[self.type .. '.png']

  self.caught_creatures = {}
  self.escaped_creatures = {}

  self.x, self.y = x, y
end

function Tetromino:draw()
  self.grid:rotate_to(math.deg(self.orientation))
  g.push('all')
  g.setColor(255, 0, 0)
  for x, y, active in self.grid:each() do
    if active then
      local s = self.size
      g.rectangle('fill', self.x + (x - 1) * s, self.y + (y - 1) * s, s, s)
    end
  end

  g.setColor(0, 255, 0)
  self.polygon:draw()
  g.pop()

  do
    local x, y = self.polygon:center()
    -- g.draw(self.image, x, y, self.orientation, 1, 1, self.size * 2, self.size * 2)
  end
end

function Tetromino:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
  self.polygon:move(dx, dy)

  for id,creature in pairs(self.caught_creatures) do
    creature:move(0, dy)
  end

  for id,creature in pairs(game.creatures) do
    if creature:isInstanceOf(SwimmingCreature)
      and not self.caught_creatures[id]
      and not self.escaped_creatures[id]
      and creature:collidesWith(self.polygon) then
      creature:gotoState('Caught', self)
      creature:move(0, dy)
      self.caught_creatures[creature.id] = creature
    elseif creature:isInstanceOf(PlantCreature)
      and creature:collidesWith(self.polygon) then
      self.caught_creatures[creature.id] = creature
    end
  end

  if self.polygon:collidesWith(game.left_bound) then
    self:move(SIZE, 0)
  elseif self.polygon:collidesWith(game.right_bound) then
    self:move(-SIZE, 0)
  elseif self.polygon:collidesWith(game.floor) then
    self:move(0, -SIZE)
    self:gotoState('Set')
  elseif collidesWithAny(self, game.set_pieces) then
    self:move(-dx, -dy)
    if dy > 0 then
      self:gotoState('Set')
    end
  end
end

return Tetromino
