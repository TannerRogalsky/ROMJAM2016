local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:draw()
  local bg = game.preloaded_images['cover_start.png']
  local iw, ih = bg:getDimensions()
  g.draw(bg, 0, 0, 0, g.getWidth() / iw)
end

function Menu:keyreleased(key)
  if key == 'escape' then
    love.event.quit()
  else
    self:gotoState('Main')
  end
end

function Menu:exitedState()
end

return Menu
