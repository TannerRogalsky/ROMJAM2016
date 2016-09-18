local SwimmingCreature = class('SwimmingCreature', Creature)

local images = {
  {
    alive = 'fish1_alive.png',
    dead = 'fish1_dead.png',
  },
  {
    alive = 'fish2_alive.png',
    dead = 'fish2_dead.png',
  },
  {
    alive = 'hallucigenia.png',
    dead = 'hallucigenia_fossil_grey.png',
  },
  {
    alive = 'needlenose_fishguy.png',
    dead = 'needlenose_fishguy_fossil.png',
  }
}

function SwimmingCreature:initialize(x, y, w, h)
  Creature.initialize(self, x, y, w, h)

  self.time_alive = love.math.random(100)

  local img = images[love.math.random(#images)]
  self.alive_image = game.preloaded_images[img.alive]
  self.dead_image = game.preloaded_images[img.dead]

  -- print(self.alive_image, img.alive)
  -- print(self.dead_image, img.dead)
end

function SwimmingCreature:update(dt)
  self.time_alive = self.time_alive + dt

  local x = self.x + math.cos(self.time_alive / 2)
  local y = self.y + math.sin(x / game.grid.width / SIZE * 10) / 2
  self:moveTo(x, y)
end

return SwimmingCreature
