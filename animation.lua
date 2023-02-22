local self = {}
-- replay is for play an animation not just once
function self.create(sprite, numFrames, xOrigin, yOrigin, w, h, fps)
  local animation = {}
  animation.sprite = sprite
  animation.numFrames = numFrames
  animation.w = w
  animation.h = h
  animation.fps = fps
  animation.timer = 0
  animation.currentFrame = 1
  animation.quads = {}

  for iFrame = 1, numFrames do
    local quad = love.graphics.newQuad(xOrigin + (iFrame-1)*w, yOrigin, w, h, sprite:getDimensions())
    table.insert(animation.quads, quad)    
  end

  return animation
end

function self.load()
end

function self.update(animation, dt)
  animation.timer = animation.timer + dt
  if (animation.timer >= 1/animation.fps) then
    animation.timer = 0
    animation.currentFrame = animation.currentFrame + 1
    if (animation.currentFrame > animation.numFrames) and animation.replay == "yes" then
      animation.currentFrame = 1
    elseif (animation.currentFrame > animation.numFrames) and animation.replay ~= "yes" then
      animation.currentFrame = animation.numFrames
    end
  end
end

function self.draw(animation, x, y)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(animation.sprite, animation.quads[animation.currentFrame], x, y, 0, 1, 1, animation.w/2, animation.h/2)
end

return self