local Dead = SwimmingCreature:addState('Dead')

function Dead:enteredState()
end

function Dead:update(dt)
end

function Dead:draw()
  local iw, ih = self.dead_image:getDimensions()
  g.draw(self.dead_image, self.x, self.y, 0, self.w / iw, self.h / ih, iw / 2, ih / 2)
end

function Dead:exitedState()
end

return Dead
