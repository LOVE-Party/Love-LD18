require "lib/SECS"

local speed = 125
local lassospeed = 5
local ropelength = 300
local ropelengthSq = ropelength*ropelength
local bulls

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

function player:init(x, y, a, b)
  self.x = x or 0
  self.y = y or 0
  self.r = 0
  self.lassor = 0
  self.gripping = false
  self.spinning = false
  self.gripped = 0
  self.arena = a
  bulls = b
  love.graphics.setLineWidth(3)
end

function player:mousepressed(x, y, button)
  if button == "l" then
    if self.gripping then
      self.gripping = false
      bulls[self.gripped].caught = false
    else
      self.spinning = true
    end
  end
end

function player:mousereleased(x, y, button)
  if button == "l" then
    if self.spinning then
      self.spinning = false
      local dist = math.huge
      local bullid = 0
      for i, bull in ipairs(bulls) do
        local angle = math.atan2(bull.y-self.y, bull.x-self.x)+0.5*math.pi
	if math.abs(angle-self.r) < 0.15 then
          local bdist = (bull.x-self.x)^2+(bull.y-self.y)^2
	  if bdist < dist then
  	    dist = bdist
	    bullid = i
	  end
	end
      end
      if dist <= ropelength^2 then
        soundmanager:play(sounds.yeehaw)
         self.gripping = true
	 self.gripped = bullid
	 bulls[bullid].caught = self
      end
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

  if self.gripping then
    local bull = bulls[self.gripped]
    local angle = math.atan2(self.y-bull.y, self.x-bull.x)-0.5*math.pi
    self.r = angle
  end
  
  --check player-caught bull distance and correct if needed
  if self.gripping then
    local bull = bulls[self.gripped]
    local dist = (self.x - bull.x) * (self.x - bull.x) + (self.y - bull.y) * (self.y - bull.y)
    if dist > ropelengthSq then
      local ropeangle = math.atan2(bull.y-self.y, bull.x-self.x)
      bull.x = self.x + ropelength*math.cos(ropeangle);
      bull.y = self.y + ropelength*math.sin(ropeangle);
    end
  end
  
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
  elseif self.gripping then
    local bull = bulls[self.gripped]
    local x, y = math.cos(self.r-0.5*math.pi)*23, math.sin(self.r-0.5*math.pi)*23
    love.graphics.setColor(104, 89, 67)
    love.graphics.line(self.x+x, self.y+y, bull.x, bull.y)
    love.graphics.setColor(255, 255, 255)
  end
end
