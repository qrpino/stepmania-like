local musicSelect = require("musicSelect")

local self = {}

  self.menu = love.audio.newSource("data/music/menu.mp3", "stream")
  self.menu:setLooping(true)
  self.tick = love.audio.newSource("data/music/tick.mp3", "static")

  self.GreenHill = love.audio.newSource("data/music/GreenHill.mp3", "stream")
  self.Bicycle = love.audio.newSource("data/music/Bicycle.mp3", "stream")
  self.Lance = love.audio.newSource("data/music/Lance.mp3", "stream")
  self.Makafushigi = love.audio.newSource("data/music/Makafushigi.mp3", "stream")
  self.GottaPower = love.audio.newSource("data/music/GottaPower.mp3", "stream")
  self.Pokemon = love.audio.newSource("data/music/Pokemon.mp3", "stream")
  self.Ah = love.audio.newSource("data/music/Ah.mp3", "stream")

function self.loadMusic()
  self.music = self[tostring(musicSelect.get())]
  self.music:setVolume(0.25)
  end

return self