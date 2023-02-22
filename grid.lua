local data = {}

local self = {}

function self.create(numLines, numColumns, x, y, sprite)
  local grid = {}
  grid.cellSprite = sprite
  grid.cellW = sprite:getWidth()
  grid.cellH = sprite:getHeight()
  for line = 1, numLines do
    grid[line] = {}
    grid[line].y = y - ((line - 1) * grid.cellH)
    for column = 1, numColumns do
      grid[line][column] = {}
      grid[line][column].x = x + ((column - 1) * grid.cellW)
      grid[line][column].value = 1
    end
    grid[line][1].angle = 90
    grid[line][2].angle = 0
    grid[line][3].angle = 180
    grid[line][4].angle = 270
  end
  return grid
end

function self.initMusic(musicGrid, x, y, w, h, speed)
  -- speed will be used to set the vertical position of the line
  musicGrid.cellW = w
  musicGrid.cellH = h
  for iLine, lines in ipairs(musicGrid) do
    musicGrid[iLine].y = y - musicGrid[iLine].timer * speed
    for iColumn, column in ipairs(lines) do
      musicGrid[iLine][iColumn].x = x + (iColumn - 1) * w
      musicGrid[iLine][iColumn].value = musicGrid[iLine][iColumn].baseValue
    end
  end
end

function self.update(musicGrid, speed, dt)
  for iLine, lines in ipairs(musicGrid) do
    musicGrid[iLine].y = musicGrid[iLine].y + speed * dt
  end
end

function self.draw(musicGrid, playerGrid)
  for iLine, lines in ipairs(playerGrid) do
    for iColumn, column in ipairs(lines) do
      love.graphics.draw(playerGrid.cellSprite, playerGrid[iLine][iColumn].x, playerGrid[iLine].y, math.rad(playerGrid[iLine][iColumn].angle), 1, 1, playerGrid.cellW/2, playerGrid.cellH/2)
    end
  end

  for iLine, lines in ipairs(musicGrid) do
    if musicGrid[iLine].y > love.graphics.getWidth() * (-1) and musicGrid[iLine].y < love.graphics.getWidth() * 2 then
      for iColumn, column in ipairs(lines) do
        if musicGrid[iLine][iColumn].value ~= 0  then
          love.graphics.draw(musicGrid.cellSprite, musicGrid.quads[iColumn], musicGrid[iLine][iColumn].x, musicGrid[iLine].y, math.rad(musicGrid[iLine][iColumn].angle), 1, 1, musicGrid.cellW/2, musicGrid.cellH/2)
        end
      end
    end
  end
end

return self