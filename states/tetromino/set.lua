local Set = Tetromino:addState('Set')

function Set:enteredState()
  self.set = true
end

function Set:exitedState()
  self.set = false
end

return Set
