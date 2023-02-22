local data = {}

local self = {}

self.defaultScaleWidth = 1280
self.defaultScaleHeight = 720

function self.getState()
  return data.state
end

function self.setState(state)
  data.state = state
end

function self.load()
  data.state = "menu"
  data.selectedMusic = nil
  self.font = love.graphics.newFont("data/fonts/SkullgirlsNormal.ttf", 40)
  love.graphics.setFont(self.font)
end

function self.update(dt)
end

function self.createButton(number, x, y)
  local buttons = {}
  buttons.sprite = love.graphics.newImage("data/sprites/buttonUi.png")
  for i=1, number do
    local button = {}
    button.w = buttons.sprite:getWidth()
    button.h = buttons.sprite:getHeight()
    button.x = x/(love.graphics.getWidth()/self.defaultScaleWidth)
    button.y = y/(love.graphics.getHeight()/self.defaultScaleHeight) + (i - 1) * button.h * 2
    table.insert(buttons, button)
  end
  return buttons
end

-- buttons is a table containing buttons, and texts is a table containing texts
function self.drawButtons(buttons, texts)
  for iButton = 1, #buttons do
    love.graphics.draw(buttons.sprite, buttons[iButton].x, buttons[iButton].y, 0, 1, 1, buttons[iButton].w/2, buttons[iButton].h/2)
    love.graphics.print(texts[iButton], buttons[iButton].x, buttons[iButton].y, 0, 1, 1, self.font:getWidth(texts[iButton])/2, self.font:getHeight(texts[iButton])/2)
  end
end

-- buttons refers to ui buttons, while clic refers to mouse button
function self.checkCursor(mouseX, mouseY, buttons, button)
  if (mouseX > button.x - button.w/2 and mouseX < button.x + button.w/2) and (mouseY > button.y - button.h/2 and mouseY < button.y + button.h/2) then
    return true
  end
end


return self