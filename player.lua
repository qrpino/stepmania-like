local sprites = require("sprites")
local animation = require("animation")
local ui = require("ui")

local data = {}

local self = {}

function self.load()
  sprites.loadPlayer()
  data.animations = {}
  data.animations.idle1 = animation.create(sprites.idle1, 17, 0, 0, sprites.idle1:getWidth()/17, sprites.idle1:getHeight(), 60, "yes")
  data.animations.idle3 = animation.create(sprites.idle3, 24, 0, 0, sprites.idle3:getWidth()/24, sprites.idle3:getHeight(), 30, "yes")
  data.animations.fail = animation.create(sprites.fail, 7, 0, 0, sprites.fail:getWidth()/7, sprites.fail:getHeight(), 20, "yes")
  data.currentAnimation = data.animations.idle3
  data.currentAnimation.currentFrame = 1
  --
  data.x = love.graphics.getWidth()/(love.graphics.getWidth()/ui.defaultScaleWidth)/2.5
  data.yDefault = love.graphics.getHeight()/(love.graphics.getHeight()/ui.defaultScaleHeight) / 1.44 -- (500 based on 720p)
  data.y = data.yDefault
  data.yFail = data.yDefault - (data.animations.fail.sprite:getHeight()/8)
end

function self.update(dt)
  -- avoid character offset
  if data.currentAnimation == data.animations.idle1 or data.currentAnimation == data.animations.idle3 then
    data.y = data.yDefault
  elseif data.currentAnimation == data.animations.fail then
    data.y = data.yFail
  end

  if data.currentAnimation == data.animations.idle1 and data.currentAnimation.currentFrame == data.currentAnimation.numFrames then
    data.currentAnimation.currentFrame = 1
    data.currentAnimation = data.animations.idle3
    data.y = data.yDefault
  elseif data.currentAnimation == data.animations.fail and data.currentAnimation.currentFrame == data.currentAnimation.numFrames then
    data.currentAnimation = data.animations.idle3
    data.y = data.yDefault
  end
--
  animation.update(data.currentAnimation, dt)
end

function self.draw()
  animation.draw(data.currentAnimation, data.x, data.y)
end

function self.setAnim(anim)
  data.currentAnimation = data.animations[anim]
  data.currentAnimation.currentFrame = 1
  if data.currentAnimation == data.animations.fail then
    data.y = data.yFail
  end
end

function self.keypressed(key)

end

return self