require "SECS"

local speed = 75

player = class:new()

function player:init(x, y, a)
  self.x = x or 0
  self.y = y or 0
  self.r = 0
  self.gripping = false
  self.spinning = false
  self.arena = a
end

function player:update(dt)
  local x, y = love.mouse.getPosition()
  self.r = math.atan2(y-self.y, x-self.x)+0.5*math.pi
  x = (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0)
  y = (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0)
  self.x = self.x + x*speed*dt
  self.y = self.y + y*speed*dt
  
  --constrain to arena
  self.x = math.max( self.x, self.arena:left()+25 );
  self.x = math.min( self.x, self.arena:right()-25 );
  self.y = math.max( self.y, self.arena:top()+25);
  self.y = math.min( self.y, self.arena:bottom()-25 );
end

function player:draw()
  local img = images.hat
  if self.gripping then img = images.hat_gripping end
  if self.spinning then img = images.hat_spinning end
  love.graphics.draw(img, self.x, self.y, self.r, 1, 1, 25, 25)
end
