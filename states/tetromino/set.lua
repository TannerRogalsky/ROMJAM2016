local Set = Tetromino:addState('Set')

function Set:enteredState()
  self.set = true

  for id,creature in pairs(self.caught_creatures) do
    table.insert(game.fossils, creature)
    game.creatures[id] = nil
    creature:gotoState('Dead')
    creature:moveTo(self.polygon:center())

    if creature:isInstanceOf(SwimmingCreature) then
      game:spawnSwimmingCreature()
    end
  end

  local x, y = PlantCreature.findSpawnLocation(SIZE, game.grid, game.set_pieces)
  local creature = PlantCreature:new(x, y, SIZE, SIZE)
  game.creatures[creature.id] = creature
end

function Set:draw()
  local x, y = self.polygon:center()
  local iw, ih = self.image:getDimensions()
  if self.type == 'I' then
    local scale = self.size * 5 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2 - self.size * 2, ih / 2)
  elseif self.type == 'T' then
    local scale = self.size * 5 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2, ih / 2 + self.size)
  elseif self.type == 'S' then
    local scale = self.size * 4 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2 - self.size * 2, ih / 2)
  elseif self.type == 'J' then
    local scale = self.size * 5 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2 - self.size, ih / 2 + self.size)
  elseif self.type == 'L' then
    local scale = self.size * 5 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2 + self.size, ih / 2 + self.size)
  elseif self.type == 'O' then
    local scale = self.size * 4 / iw
    g.draw(self.image, x, y, self.orientation, scale, scale, iw / 2, ih / 2)
  end

  for id,creature in pairs(self.caught_creatures) do
    creature:draw()
  end
end

function Set:exitedState()
  self.set = false
end

return Set
