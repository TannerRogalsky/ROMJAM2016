local Over = Game:addState('Over')

function Over:enteredState()
  self.input_timer = 1

  g.setFont(self.preloaded_fonts["04b03_36"])
end

function Over:draw()
  local bg = game.preloaded_images['cover_end.png']
  local iw, ih = bg:getDimensions()
  g.draw(bg, 0, 0, 0, g.getWidth() / iw)

  g.print(#self.fossils, 0.6298828125 * g.getWidth(), 0.098 * g.getHeight())

  local x = 5
  local y = g.getWidth() / 4

  for i,creature in ipairs(self.fossils) do
    local iw, ih = creature.dead_image:getDimensions()
    local sx, sy = creature.w / iw, creature.h / ih
    g.draw(creature.dead_image, x, y, 0, sx, sy)
    x = x + creature.w * 1.5
  end
end

function Over:update(dt)
  self.input_timer = self.input_timer - dt
end

function Over:keyreleased()
  if self.input_timer < 0 then
    self:gotoState('Menu')
  end
end

function Over:exitedState()
end

return Over
