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

local images = {
  {
    alive = 'common-sponge.png',
    dead = 'common-sponge_fossil_grey.png',
  },
  {
    dead = 'filter-plant-fossil.png',
    alive = 'filter-plant.png',
  }
}

function PlantCreature:initialize(x, y, w, h)
  Creature.initialize(self, x, y, w, h)

  local img = images[love.math.random(#images)]
  self.alive_image = game.preloaded_images[img.alive]
  self.dead_image = game.preloaded_images[img.dead]
end

function PlantCreature:update(dt)
end

function PlantCreature:draw()
  if game.debug then
    g.push('all')
    g.setColor(0, 0, 255)
    self.collider:draw()
    g.pop()
  end

  local iw, ih = self.alive_image:getDimensions()
  g.draw(self.alive_image, self.x, self.y, 0, self.w / iw, self.h / ih)
end

return PlantCreature
