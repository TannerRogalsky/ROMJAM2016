local Set = Tetromino:addState('Set')

function Set:enteredState()
  self.set = true

  for id,creature in pairs(self.caught_creatures) do
    table.insert(game.fossils, creature)
    game.creatures[id] = nil
    creature:gotoState('Dead')
    creature:moveTo(self.polygon:center())
  end
end

function Set:draw()
  self.grid:rotate_to(math.deg(self.orientation))
  g.push('all')
  g.setColor(255, 0, 0)
  for x, y, active in self.grid:each() do
    if active then
      local s = self.size
      g.rectangle('fill', self.x + (x - 1) * s, self.y + (y - 1) * s, s, s)
    end
  end

  g.setColor(0, 255, 0)
  self.polygon:draw()
  g.pop()

  do
    local x, y = self.polygon:center()
    -- g.draw(self.image, x, y, self.orientation, 1, 1, self.size * 2, self.size * 2)
  end

  for id,creature in pairs(self.caught_creatures) do
    creature:draw()
  end
end

function Set:exitedState()
  self.set = false
end

return Set
