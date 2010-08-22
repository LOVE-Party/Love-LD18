require "lib/SECS"

arena = class:new()

function arena:init(x, y, w, h)
  self.width = w or 1024
  self.height = h or 1024
  self.x = x or 0
  self.y = y or 0
end

function arena:update(dt)
  --probably spawn bulls here!
end

function arena:left()
  return (self.x + 128)
end

function arena:right()
  return (self.width - 128)
end

function arena:top()
  return (self.y + 128)
end

function arena:bottom()
  return (self.height - 128)
end

function arena:draw()
  love.graphics.setColor(236,227,200)
  love.graphics.rectangle("fill", self.x+126, self.y+126, self.width-248, self.height-248)
  love.graphics.setColor(255,255,255)
  --draw top walls
  for i = 128, self.width-256, 256 do
    love.graphics.draw(images.walltiles.top, i, self.y+30)
  end
  --draw left walls
  for i = 128, self.height-256, 256 do
    love.graphics.draw(images.walltiles.left, self.x+30, i)
  end
  --draw right walls
  for i = 128, self.height-256, 256 do
    love.graphics.draw(images.walltiles.right, self.x+self.width-154, i)
  end
  --draw bottom walls
  for i = 128, self.width-256, 256 do
    love.graphics.draw(images.walltiles.bottom, i, self.y+self.height-154)
  end
  --draw corners
  love.graphics.draw(images.walltiles.topleft, self.x+30, self.y+30)
  love.graphics.draw(images.walltiles.topright, self.width-128, self.y+30)
  love.graphics.draw(images.walltiles.bottomleft, self.x+30, self.height-128)
  love.graphics.draw(images.walltiles.bottomright, self.width-128, self.height-128)
end
