local ui = require("ui")
local playing = require("playing")
local sounds = require("sounds")
local musicSelect = require("musicSelect")
local sprites = require("sprites")

local data = {}

local self = {}

function self.load()
  sounds.menu:play()
  data.musicSelection = false
  data.musicList = {"GreenHill", "Bicycle", "Lance", "Makafushigi", "GottaPower", "Pokemon", "Ah"}
  data.menuSprite = sprites.menu
  data.musicId = 1
  data.buttons = ui.createButton(3, love.graphics.getWidth()/2, love.graphics.getHeight()/2.5)
  data.buttonsText = {"Play", "Settings", "Quit"}
  data.buttonsMusic = ui.createButton(2, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  data.buttonsTextMusic = {data.musicList[data.musicId], "Back"}
end

function self.draw()
  if ui.getState() ~= "playing" then
    love.graphics.draw(data.menuSprite)
  end
  if ui.getState() == "menu" and data.musicSelection == false then
    ui.drawButtons(data.buttons, data.buttonsText)
  elseif ui.getState() == "menu" and data.musicSelection == true then
    ui.drawButtons(data.buttonsMusic, data.buttonsTextMusic)
    love.graphics.print("Hit Left or Right to change the music", data.buttonsMusic[1].x, data.buttonsMusic[1].y - data.buttonsMusic[1].h, 0, 1, 1, ui.font:getWidth("Hit Left or Right to change the music")/2, ui.font:getHeight("Hit Left or Right to change the music")/2)
  end
end

function self.mousepressed(x, y, button)
  if ui.getState() == "menu" and data.musicSelection == false then
    if ui.checkCursor(x, y, data.buttons, data.buttons[1]) then
      data.musicSelection = true
    elseif ui.checkCursor(x, y, data.buttons, data.buttons[2]) then
      ui.setState("settings")
    elseif ui.checkCursor(x, y, data.buttons, data.buttons[3]) then
      love.event.quit()
    end
  elseif ui.getState() == "menu" and data.musicSelection == true then
    if ui.checkCursor(x, y, data.buttonsMusic, data.buttonsMusic[1]) then
      musicSelect.set(data.musicList[data.musicId])
      sounds.menu:stop()
      ui.setState("playing")
      playing.load()
    elseif ui.checkCursor(x, y, data.buttonsMusic, data.buttonsMusic[2]) then
      data.musicSelection = false
    end
  end
end

function self.keypressed(key)
  if ui.getState() == "menu" and data.musicSelection == false then
    if (key == "escape") then
      love.event.quit()
    end
  elseif ui.getState() == "menu" and data.musicSelection == true then
    if (key == "left") then
      if data.musicId > 1 then
        data.musicId = data.musicId - 1
      elseif data.musicId == 1 then
        data.musicId = #data.musicList
      end
      data.buttonsTextMusic = {data.musicList[data.musicId], "Back"}
    elseif (key == "right") then
      if data.musicId < #data.musicList then
        data.musicId = data.musicId + 1
      elseif data.musicId == #data.musicList then
        data.musicId = 1
      end
      data.buttonsTextMusic = {data.musicList[data.musicId], "Back"}
    elseif (key == "escape") then
      data.musicSelection = false
    end
  end
end

return self