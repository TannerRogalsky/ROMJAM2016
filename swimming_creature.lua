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

function SwimmingCreature:initialize(x, y, size)
  local img = images[love.math.random(#images)]
  self.alive_image = game.preloaded_images[img.alive]
  self.dead_image = game.preloaded_images[img.dead]

  local iw, ih = self.alive_image:getDimensions()
  Creature.initialize(self, x, y, iw * SIZE / 50, ih * SIZE / 50)

  self.time_alive = love.math.random(100)

  self.dx, self.dy = 0, 0

  -- print(self.alive_image, img.alive)
  -- print(self.dead_image, img.dead)
end

function Creature:draw()
  if game.debug then
    g.push('all')
    g.setColor(0, 0, 255)
    self.collider:draw()
    g.pop()
  end

  local direction_scale = 1
  if self.dx > 0 then
    direction_scale = -1
  end

  local iw, ih = self.alive_image:getDimensions()
  g.draw(self.alive_image, self.x, self.y, 0, self.w / iw * direction_scale, self.h / ih, iw / 2, ih / 2)
end

function SwimmingCreature:update(dt)
  self.time_alive = self.time_alive + dt

  local dx = math.cos(self.time_alive / 2)
  local x = self.x + dx

  local dy = math.sin(x / game.grid.width / SIZE * 10) / 2
  self.dx, self.dy = dx, dy

  local y = self.y + dy
  self:moveTo(x, y)
end

return SwimmingCreature
