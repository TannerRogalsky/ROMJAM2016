local Creature = class('Creature', Base):include(Stateful)

function Creature:initialize(x, y, w, h)
  Base.initialize(self)
  self.x, self.y = x, y
  self.w, self.h = w, h

  self.collider = HC.rectangle(x, y, w, h)
end

function Creature:update(dt)

end

function Creature:draw()
  if game.debug then
    g.push('all')
    g.setColor(0, 0, 255)
    self.collider:draw()
    g.pop()
  end

  local iw, ih = self.alive_image:getDimensions()
  g.draw(self.alive_image, self.x, self.y, 0, self.w / iw, self.h / ih, iw / 2, ih / 2)
end

function Creature:collidesWith(other)
  return self.collider:collidesWith(other)
end

function Creature:move(dx, dy)
  self.x, self.y = self.x + dx, self.y + dy
  self.collider:move(dx, dy)
end

function Creature:moveTo(x, y)
  self.x, self.y = x, y
  self.collider:moveTo(x, y)
end

return Creature
