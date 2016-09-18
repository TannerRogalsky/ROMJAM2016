local PlantCreature = class('PlantCreature', Creature)
function PlantCreature.static.findSpawnLocation(size, grid, set_pieces)
  local row = love.math.random(grid.width) - 1
  local x = row * size
  for col=0,grid.height - 1 do
    local y = col * size
    for _,tetromino in pairs(set_pieces) do
      if tetromino.polygon:contains(x + size * 0.5, y + size * 0.5) then
        return x, y - size
      end
    end
  end

  return x, (grid.height - 3) * size
end

function PlantCreature:initialize(x, y, w, h)
  Creature.initialize(self, x, y, w, h)
end

function PlantCreature:update(dt)
end

return PlantCreature
