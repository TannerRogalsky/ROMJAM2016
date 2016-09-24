local FallingFast = Tetromino:addState('FallingFast')

local function linear(t, b, c, d) return c * t / d + b end

function FallingFast:enteredState()
  assert(type(self.x) == 'number')
  assert(type(self.y) == 'number')

  self.drop_time = 0.08
  self.drop_timer = 0

  self.speed = SIZE / self.drop_time
end

function FallingFast:update(dt)
  self.drop_timer = self.drop_timer + dt

  if self.drop_timer >= self.drop_time then
    self.drop_timer = self.drop_timer - self.drop_time
    self.drop_time = self.drop_time * 0.99

    self:move(0, SIZE)
  end

  self.speed = SIZE / self.drop_time
end

function FallingFast:keyreleased(key, scancode)
  if key == 'down' then
    self:gotoState('Falling')
  end
end

function FallingFast:exitedState()
end

return FallingFast
