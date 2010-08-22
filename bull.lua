require "lib/SECS"

local speed = 75

bull = class:new()

function bull:init(x, y, a)
  self.x = x or 0
  self.y = y or 0
  self.r = 0
  self.cought = false
  self.arena = a
end

function bull:update(dt)
--  local x, y = love.mouse.getPosition()
--  self.r = math.atan2(y-self.y, x-self.x)+0.5*math.pi
  x = math.random(-1, 1)
  y = math.random(-1, 1)
  r = math.random(-0.1, 0.1)+0.5*math.pi
  self.x = self.x + x*speed*dt
  self.y = self.y + y*speed*dt
  self.r = self.r + (r*speed*dt)*0.01
  
  --constrain to arena
  self.x = math.max( self.x, self.arena:left()+38 );
  self.x = math.min( self.x, self.arena:right()-38 );
  self.y = math.max( self.y, self.arena:top()+70);
  self.y = math.min( self.y, self.arena:bottom()-70 );
end

function bull:draw()
  local img = images.bull
  if self.cought then img = images.bull_cought end
  love.graphics.draw(img, self.x, self.y, self.r, 1, 1, 25, 25)
end
