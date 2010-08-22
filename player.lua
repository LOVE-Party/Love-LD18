require "lib/SECS"

local speed = 125
local lassospeed = 5

player = class:new()

local function getkey(k)
  local lk = love.keyboard
  if k == 'up' then 
    return lk.isDown("w") or lk.isDown("up") 
  elseif k == 'down' then 
    return lk.isDown("s") or lk.isDown("down")
  elseif k == 'left' then 
    return lk.isDown("a") or lk.isDown("left")
  elseif k == 'right' then 
    return lk.isDown("d") or lk.isDown("right")
  end
end

function player:init(x, y, a)
  self.x = x or 0
  self.y = y or 0
  self.r = 0
  self.lassor = 0
  self.gripping = false
  self.spinning = false
  self.arena = a
end

function player:mousepressed(x, y, button)
  if button == "l" then
    if self.gripping then
      self.gripping = false
    else
      self.spinning = true
    end
  end
end

function player:mousereleased(x, y, button)
  if button == "l" then
    if self.spinning then
      self.spinning = false
      self.gripping = true
    end
  end
end

function player:update(dt)
  local x, y = love.mouse.getPosition()
  self.r = math.atan2(y-300, x-400)+0.5*math.pi
  self.lassor = self.lassor + lassospeed*dt
  x = (getkey("right") and 1 or 0) - (getkey("left") and 1 or 0)
  y = (getkey("down") and 1 or 0) - (getkey("up") and 1 or 0)
  self.x = self.x + x*speed*dt
  self.y = self.y + y*speed*dt
  
  --constrain to arena
  self.x = math.max(self.x, self.arena:left()+25)
  self.x = math.min(self.x, self.arena:right()-25)
  self.y = math.max(self.y, self.arena:top()+25)
  self.y = math.min(self.y, self.arena:bottom()-25)
end

function player:center()
  love.graphics.translate(400-self.x, 300-self.y)
end

function player:draw()
  local img = images.hat
  if self.gripping then img = images.hat_gripping end
  if self.spinning then img = images.hat_spinning end
  love.graphics.draw(img, self.x, self.y, self.r, 1, 1, 25, 25)
  if self.spinning then
    local x, y = math.cos(self.r)*40, math.sin(self.r)*40
    love.graphics.draw(images.lasso, self.x+x, self.y+y, self.lassor, 1, 1, 12, 12)
  end
end
