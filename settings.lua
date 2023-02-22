local ui = require("ui")
--local musicSelect = require("musicSelect")

local data = {}

local self = {}

function self.getVolume()
  return data.volume
end

function self.getDifficulty()
  return data.difficulty
end


function self.load()
  data.backButton = ui.createButton(1, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  data.backButtonText = {"Back"}
  data.volumeButtons = ui.createButton(2, love.graphics.getWidth()/2 - data.backButton[1].w * 2, love.graphics.getHeight()/2)
  data.volumeButtonsText = {"Volume +", "Volume -"}
  data.difficultyButtons = ui.createButton(2, love.graphics.getWidth()/2 + data.backButton[1].w * 2, love.graphics.getHeight()/2)
  data.difficultyButtonsText = {"Difficulty +", "Difficulty -"}
  data.videoButton = ui.createButton(1, love.graphics.getWidth()/2, love.graphics.getHeight()/2 - data.backButton[1].h * 2)
  data.videoButtonText = {"Fullscreen"}
  data.volume = 1
  data.difficulty = 300
end

function self.update(dt)

end

function self.draw()
  if ui.getState() == "settings" then
    ui.drawButtons(data.backButton, data.backButtonText)
    ui.drawButtons(data.volumeButtons, data.volumeButtonsText)
    love.graphics.print("Volume : " .. (data.volume), data.volumeButtons[1].x, data.volumeButtons[1].y - data.volumeButtons[1].h, 0, 1, 1, ui.font:getWidth("Volume : " .. data.volume)/2, ui.font:getHeight("Volume : " .. data.volume)/2)
    ui.drawButtons(data.difficultyButtons, data.difficultyButtonsText)
    love.graphics.print("Difficulty : " .. (data.difficulty/100), data.difficultyButtons[1].x, data.difficultyButtons[1].y - data.difficultyButtons[1].h, 0, 1, 1, ui.font:getWidth("Difficulty : " .. data.difficulty/100)/2, ui.font:getHeight("Difficulty : " .. data.difficulty/100)/2)
    ui.drawButtons(data.videoButton, data.videoButtonText)
  end
end

function self.mousepressed(x, y, button)

  if ui.getState() == "settings" then
    if ui.checkCursor(x, y, data.backButton, data.backButton[1]) then
      ui.setState("menu")
    elseif ui.checkCursor(x, y, data.volumeButtons, data.volumeButtons[2]) then
      if data.volume > 0.11 then
        data.volume = data.volume - 0.1
      end
    elseif ui.checkCursor(x, y, data.volumeButtons, data.volumeButtons[1]) then
      if data.volume < 1 then
        data.volume = data.volume + 0.1
      end
    elseif ui.checkCursor(x, y, data.difficultyButtons, data.difficultyButtons[2]) then
      if data.difficulty > 100 then
        data.difficulty = data.difficulty - 100
      end
    elseif ui.checkCursor(x, y, data.difficultyButtons, data.difficultyButtons[1]) then
      data.difficulty = data.difficulty + 100
    elseif ui.checkCursor(x, y, data.videoButton, data.videoButton[1]) then
      love.window.setFullscreen(not love.window.getFullscreen())
    end
  end
end

function self.keypressed(key)
  if ui.getState() == "settings" then
    if (key == "escape") then
      ui.setState("menu")
    end
  end
end

return self