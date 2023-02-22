local ui = require("ui")
local menu = require("menu")
local settings = require("settings")
local playing = require("playing")
local sounds = require("sounds")

local data = {}

local self = {}

function self.load()
  data.defaultScale = 1280
  ui.load()
  menu.load()
  settings.load()
end

function self.update(dt)
  data.mouseX = love.mouse.getX() / (  love.graphics.getWidth() / ui.defaultScaleWidth)
  data.mouseY = love.mouse.getY() / (  love.graphics.getWidth() / ui.defaultScaleWidth)
  playing.update(dt)
end

function self.draw()
  love.graphics.scale(love.graphics.getWidth()/ui.defaultScaleWidth)
  menu.draw()
  settings.draw()
  playing.draw()
end

function self.keypressed(key)
  menu.keypressed(key)
  settings.keypressed(key)
  playing.keypressed(key)
end

function self.mousepressed(x, y, button)
  menu.mousepressed(data.mouseX, data.mouseY, button)
  settings.mousepressed(data.mouseX, data.mouseY, button)
  playing.mousepressed(data.mouseX, data.mouseY, button)
end

return self