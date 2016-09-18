local Over = Game:addState('Over')

function Over:enteredState()
end

function Over:draw()
  g.print('GAME OVER')
end

function Over:exitedState()
end

return Over
