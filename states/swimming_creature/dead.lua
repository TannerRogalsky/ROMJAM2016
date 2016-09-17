local Dead = SwimmingCreature:addState('Dead')

function Dead:enteredState()
end

function Dead:update(dt)
end

function Dead:draw()
  g.push('all')
  g.setColor(0, 255, 255)
  self.collider:draw()
  g.pop()
end

function Dead:exitedState()
end

return Dead
