local Caught = SwimmingCreature:addState('Caught')
local TIME_TO_ESCAPE = 5

function Caught:enteredState(catcher)
  self.caught_timer = 0
  self.catcher = catcher
end

function Caught:update(dt)
  self.caught_timer = self.caught_timer + dt

  if self.caught_timer >= TIME_TO_ESCAPE then
    self.catcher.caught_creatures[self.id] = nil
    self.catcher.escaped_creatures[self.id] = self
    self:gotoState()
  end
end

function Caught:exitedState()
  self.catcher = nil
end

return Caught
