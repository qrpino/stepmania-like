local ui = require("ui")
local player = require("player")
local sprites = require("sprites")
local musicSelect = require("musicSelect")
local settings = require("settings")
local grid = require("grid")
local musicGrid
local sounds = require("sounds")
local playerGrid = {}

local data = {}

local function playSound(source)
  local clone = source
  clone:play()
end

local function addScore(value)
  data.score = math.floor(data.score + value * data.multiplier)
end

local function checkNote(key)
  if (key == "left" or key == "down" or key == "up" or key == "right" ) then
    player.setAnim("idle1")

    local lineFinder = data.gridCurrentLine
    local columnId

    if (key == "left") then
      columnId = 1
    elseif (key == "down") then
      columnId = 2
    elseif (key == "up") then
      columnId = 3
    elseif (key == "right") then
      columnId = 4
    end

    while musicGrid[lineFinder][columnId].value ~= 1 and lineFinder ~= #musicGrid do
      lineFinder = lineFinder + 1
    end

    if musicGrid[lineFinder].y + musicGrid.cellH/2 > playerGrid[1].y - (playerGrid.cellH/2) * 2 and musicGrid[lineFinder].y - musicGrid.cellH/2 < playerGrid[1].y + playerGrid.cellH/2 then
      musicGrid[lineFinder][columnId].value = 0
      playSound(sounds.tick)
      data.combo = data.combo + 1
      addScore(100)
      if data.life < data.lifeMax then
        data.life = data.life + 0.01
      end
    else
      player.setAnim("fail")
      data.combo = 0
      data.life = data.life - 0.05
    end
  end
end

local function loadMusic()
  data.gridCurrentLine = 1
  data.startMusic = false
  grid.initMusic(musicGrid, data.gridX, data.gridY, data.cellW, data.cellH, data.gridSpeed)
end

local function createQuads(numQuads, x, y, sprite)
  local quads = {}
  local w = sprite:getWidth()
  local h = sprite:getHeight()
  for i=1, numQuads do
    local quad = love.graphics.newQuad(x, y + (i - 1) * w/numQuads, w/numQuads, h/numQuads, w, h)
    table.insert(quads, quad)
  end
  return quads
end


local self = {}

function self.setVolume(value)
  data.music:setVolume(value)
end

function self.setDifficulty(value)
  data.gridSpeed = value
end

function self.load()
  musicGrid = require("/data/music/"..tostring(musicSelect.current))
  data.over = false
  data.combo = 0
  data.score = 0
  data.scoreMax = #musicGrid
  data.multiplier = 1
  data.life = 1
  data.lifeMax = 1
  sprites.loadLevel()
  sprites.loadGrid()
  playerGrid.cellSprite = sprites.emptyArrow
  musicGrid.cellSprite = sprites.arrows
  musicGrid.quads = createQuads(4, 0, 0, musicGrid.cellSprite)
  data.pause = false
  data.finished = false
  data.timer = 0
  data.cellW = playerGrid.cellSprite:getWidth()
  data.cellH = playerGrid.cellSprite:getHeight()
  data.gridX = love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/20
  data.gridY = love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight)/1.25
  data.gridSpeed = settings.getDifficulty()
  loadMusic()
  playerGrid = grid.create(1, 4, data.gridX, data.gridY, playerGrid.cellSprite)
  data.buttons = ui.createButton(3, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  data.buttonsText = {"Continue", "Replay", "Menu"}
  data.background = sprites.level
  player.load()
  sounds.loadMusic()
  sounds.music:setVolume(settings.getVolume())
end

function self.update(dt)
  if ui.getState() == "playing" and data.pause == false and data.over == false and data.finished == false then
    if data.life < 0 then
      data.life = 0
      data.over = true
    end
    player.update(dt)
    if data.combo > data.scoreMax/20 then
      data.multiplier = 2
    elseif data.combo > data.scoreMax/15 then
      data.multiplier = 3
    elseif data.combo > data.scoreMax/10 then
      data.multiplier = 4
    elseif data.combo > data.scoreMax/5 then
      data.multiplier = 5
    elseif data.combo > data.scoreMax/2 then
      data.multiplier = 10
    end
    if data.startMusic == true then
      grid.update(musicGrid, data.gridSpeed, dt)
      if playerGrid[1].y < musicGrid[data.gridCurrentLine].y - musicGrid.cellH/2 then
        if musicGrid[data.gridCurrentLine][1].value == 1 or musicGrid[data.gridCurrentLine][2].value == 1 or musicGrid[data.gridCurrentLine][3].value == 1 or musicGrid[data.gridCurrentLine][4].value == 1 then
          player.setAnim("fail")
          data.combo = 0
          data.multiplier = 1
          data.life = data.life - 0.05
        end
        if data.gridCurrentLine ~= #musicGrid then
          data.gridCurrentLine = data.gridCurrentLine + 1
        elseif data.gridCurrentLine == #musicGrid then
          data.timer = data.timer + dt
          if data.timer >= 2 then
            data.timer = 2
            data.finished = true
          end
        end
      end
    end
  elseif ui.getState() == "playing" and data.over == true or data.finished == true then
    data.pause = true
    sounds.music:stop()
  end
end

function self.draw()
  if ui.getState() == "playing" then
    love.graphics.draw(data.background)
    love.graphics.draw(sprites.gridBackground, musicGrid[1][1].x - 64/2, 0)
    player.draw()
    grid.draw(musicGrid, playerGrid)
    love.graphics.print("Combo : " .. data.combo, love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/3, love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight)/1.1, 0, 1.2, 1.2, ui.font:getWidth("Combo : " .. data.combo)/2, ui.font:getHeight("Combo : " .. data.combo)/2)
    love.graphics.print("X".. data.multiplier, love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/2.25, love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight)/1.1, 0, 1.2, 1.2, ui.font:getWidth("X".. data.multiplier)/2, ui.font:getHeight("X".. data.multiplier)/2)
    love.graphics.print("Score : " .. data.score, love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/1.75, love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight)/1.1, 0, 1.2, 1.2, ui.font:getWidth("Score : " .. data.score)/2, ui.font:getHeight("Score : " .. data.score)/2)
    if data.startMusic == false then
      love.graphics.print("Press spacebar to start!", love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/2, love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight)/2, 0, 1, 1, ui.font:getWidth("Press spacebar to start!")/2, ui.font:getHeight("Press spacebar to start!")/2)
    end
    if data.pause == true or data.over == true then
      ui.drawButtons(data.buttons, data.buttonsText)
    end
    if data.over == true then
      love.graphics.print("You losed, try again!", love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/2, data.buttons[1].y - data.buttons[1].h * 2, 0, 1.2, 1.2, ui.font:getWidth("You losed, try again!"), ui.font:getHeight("You losed, try again!"))
    elseif data.finished == true then
      love.graphics.print("Congrats, you Won! Your score : ".. data.score, love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/2, data.buttons[1].y - data.buttons[1].h, 0, 1.2, 1.2, ui.font:getWidth("Congrats, you Won! Your score : ".. data.score)/2, ui.font:getHeight("Congrats, you Won! Your score : ".. data.score))
    end
    love.graphics.print("Player HP : " ..data.life * 100, love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/25, love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight) - ui.font:getHeight("Player HP : " ..data.life * 100))
  end
end

function self.keypressed(key)
  if ui.getState() == "playing" and data.over == false and data.finished == false then
    if data.pause == false  then
      if (key == "space") then
        data.startMusic = true
        -------------------
        sounds.music:play()
        -------------------
      elseif data.startMusic == true then
        checkNote(key)
      end
    end
    if (key == "escape") and (data.pause == false) then
      data.pause = true
      -------------------
      sounds.music:pause()
      -------------------
    elseif (key == "escape") and (data.pause == true) then
      data.pause = false
      sounds.music:play()
    end
  end
end

function self.mousepressed(x, y, button)
  if ui.getState() == "playing" and data.pause == true then
    if ui.checkCursor(x, y, data.buttons, data.buttons[1]) and data.over == false and data.finished == false then
      data.pause = false
    elseif  ui.checkCursor(x, y, data.buttons, data.buttons[2]) then
      data.life = data.lifeMax
      data.over = false
      data.finished = false
      -------------------
      sounds.music:stop()
      -------------------
      data.combo = 0
      data.score = 0
      data.multiplier = 1
      loadMusic()
      data.pause = false
    elseif ui.checkCursor(x, y, data.buttons, data.buttons[3]) then
      ui.setState("menu")
      data.finished = false
      data.over = false
      data.score = 0
      data.multiplier = 1
      data.combo = 0
      sounds.music:stop()
      sounds.menu:play()
    end
  end
end

return self