local Dead = PlantCreature:addState('Dead')

function Dead:enteredState()
end

function Dead:update(dt)
end

function Dead:draw()
  g.push('all')
  g.setColor(255, 0, 0)
  local iw, ih = self.dead_image:getDimensions()
  g.draw(self.dead_image, self.x, self.y, 0, self.w / iw, self.h / ih, iw / 2, ih / 2)
  g.pop()
end

function Dead:exitedState()
end

return Dead
