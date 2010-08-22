require "lib/SECS"

local speed = 200

bull = class:new()

function bull:init(x, y, a)
  self.x = x or 0
  self.y = y or 0
  self.dir = math.random() * math.pi
  self.dirX = math.cos(self.dir)
  self.dirY = math.sin(self.dir)
  self.dur = math.random(1,3)
  self.r = 0
  self.caught = false
  self.arena = a
end

function bull:update(dt)
  self.dur = self.dur - dt
  
  if self.dur <= 0 then
    local x,y = self.arena:center()
    local r = math.atan2(y-self.y, x-self.x)
    self.dir = r + ((math.random() * math.pi) - (math.pi * 0.5))
    self.dirX = math.cos(self.dir)
    self.dirY = math.sin(self.dir)
    self.dur = math.random(1,4)
  end
  
  self.x = self.x + self.dirX*speed*dt
  self.y = self.y + self.dirY*speed*dt
  self.r = self.dir + (math.pi * 0.5)

  --constrain to arena
  self.x = math.max(self.x, self.arena:left()+38)
  self.x = math.min(self.x, self.arena:right()-38)
  self.y = math.max(self.y, self.arena:top()+70)
  self.y = math.min(self.y, self.arena:bottom()-70)
end

function bull:draw()
  local img = images.bull
  if self.caught then img = images.bull_caught end
  love.graphics.draw(img, self.x, self.y, self.r, 1, 1, 25, 25)
end
