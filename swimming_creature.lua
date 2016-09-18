local SwimmingCreature = class('SwimmingCreature', Creature)

function SwimmingCreature:initialize(x, y, w, h)
  Creature.initialize(self, x, y, w, h)

  self.time_alive = love.math.random(100)
end

function SwimmingCreature:update(dt)
  self.time_alive = self.time_alive + dt

  local x = self.x + math.cos(self.time_alive / 2)
  local y = self.y + math.sin(x / game.grid.width / SIZE * 10) / 2
  self:moveTo(x, y)
end

return SwimmingCreature
