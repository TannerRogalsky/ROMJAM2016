local FallingFast = Tetromino:addState('FallingFast')

function FallingFast:enteredState()
  assert(type(self.x) == 'number')
  assert(type(self.y) == 'number')

  self.drop_timer = cron.every(0.08, function()
    self:move(0, SIZE)
  end)
end

function FallingFast:update(dt)
  self.drop_timer:update(dt)
end

function FallingFast:keyreleased(key, scancode)
  if key == 'down' then
    self:gotoState('Falling')
  end
end

function FallingFast:exitedState()
end

return FallingFast
