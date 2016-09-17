local SwimmingCreature = class('SwimmingCreature', Creature)

function SwimmingCreature:initialize(x, y, w, h)
  Creature.initialize(self, x, y, w, h)
end

function SwimmingCreature:update(dt)
  local x = self.x + 15 * dt
  local y = self.y + math.sin(x / game.grid.width / SIZE * 10) / 2
  self:moveTo(x, y)
end

return SwimmingCreature
