local Falling = Tetromino:addState('Falling')
local INPUT_TIME = 0.1
local DROP_INTERVAL = 1
local lk = love.keyboard

function Falling:enteredState()
  assert(type(self.x) == 'number')
  assert(type(self.y) == 'number')

  self.input_timer = 0

  self.drop_timer = cron.every(DROP_INTERVAL, function()
    self:move(0, SIZE)
  end)

  self.speed = SIZE / DROP_INTERVAL
end

function Falling:update(dt)
  self.drop_timer:update(dt)

  self.input_timer = self.input_timer + dt
  if self.input_timer >= INPUT_TIME then
    if lk.isDown('left') then
      self:move(-SIZE, 0)
      self.input_timer = 0
    elseif lk.isDown('right') then
      self:move(SIZE, 0)
      self.input_timer = 0
    end
  end
end

function Falling:keypressed(key, scancode, isrepeat)
  if key == 'up' then
    self.orientation = (self.orientation + math.pi / 2) % (math.pi * 2)
    local piece_size = self.grid.width
    self.polygon:setRotation(self.orientation,
      self.x + self.size * (piece_size / 2),
      self.y + self.size * (piece_size / 2))

    while self.polygon:collidesWith(game.right_bound) do
      self:move(-SIZE, 0)
    end

    while self.polygon:collidesWith(game.left_bound) do
      self:move(SIZE, 0)
    end
  elseif key == 'down' then
    self:gotoState('FallingFast')
  end
end

function Falling:exitedState()
end

return Falling
