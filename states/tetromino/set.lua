local Set = Tetromino:addState('Set')
local renderTetromino = require('shared.render_tetromino')

function Set:enteredState()
  local caughtFossil = false
  self.set = true

  for id,creature in pairs(self.caught_creatures) do
    caughtFossil = true

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

  if caughtFossil then
    game.soundManager:playSound(game.soundManager.SFX.FOSSIL_IMPACT)
  end

  game.soundManager:playSound(game.soundManager.SFX.PIECE_IMPACT)
end

function Set:draw()
  renderTetromino(self, self.polygon:center())

  for id,creature in pairs(self.caught_creatures) do
    creature:draw()
  end
end

function Set:exitedState()
  self.set = false
end

return Set
