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
  local cell_width = iw / 40
  local scale = self.size * cell_width / iw
  if self.type == 'I' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.4, ih * 0.5)
  elseif self.type == 'T' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.5, ih * 0.55)
  elseif self.type == 'S' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.375, ih * 0.5)
  elseif self.type == 'J' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.45, ih * 0.55)
  elseif self.type == 'L' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.55, ih * 0.55)
  elseif self.type == 'O' then
    g.draw(self.image, x, y, self.orientation, scale, scale, iw * 0.5, ih * 0.5)
  end

  for id,creature in pairs(self.caught_creatures) do
    creature:draw()
  end
end

function Set:exitedState()
  self.set = false
end

return Set
