local self = {}

self.menu = love.graphics.newImage("data/sprites/menu.jpg")
self.uiButton = love.graphics.newImage("data/sprites/buttonUi.png")

function self.loadPlayer()
  self.idle1 = love.graphics.newImage("data/sprites/spritesheet/idle1.png")
  self.idle3 = love.graphics.newImage("data/sprites/spritesheet/idle3.png")
  self.fail = love.graphics.newImage("data/sprites/spritesheet/fail.png")
end

function self.loadLevel()
  self.level = love.graphics.newImage("data/sprites/level.png")
end

function self.loadGrid()
  self.gridBackground = love.graphics.newImage("data/sprites/gridBackground.png")
  self.arrows = love.graphics.newImage("data/sprites/spritesheet/arrows.png")
  self.emptyArrow = love.graphics.newImage("data/sprites/spritesheet/arrowBlank.png")
end

return self