local function renderTetromino(tetromino, x, y)
  local iw, ih = tetromino.image:getDimensions()
  local cell_width = iw / 40
  local scale = tetromino.size * cell_width / iw
  if tetromino.type == 'I' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.4, ih * 0.5)
  elseif tetromino.type == 'T' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.5, ih * 0.55)
  elseif tetromino.type == 'S' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.375, ih * 0.5)
  elseif tetromino.type == 'J' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.45, ih * 0.55)
  elseif tetromino.type == 'L' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.55, ih * 0.55)
  elseif tetromino.type == 'O' then
    g.draw(tetromino.image, x, y, tetromino.orientation, scale, scale, iw * 0.5, ih * 0.5)
  end
end

return renderTetromino
