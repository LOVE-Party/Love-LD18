require "lib/SECS"
require "lib/AnAL"

local speed = 125
local lassospeed = 10
local lassothrowspeed = 10
local ropelength = 300
local ropelengthSq = ropelength^2
local bulls
local walkAnim
local spinAnim

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

function player:init(x, y, a, b, c)
  self.x = x or 0
  self.y = y or 0
  self.r = 0
  self.lassor = 0
  self.gripping = false
  self.spinning = false
  self.gripped = 0
  self.moving = false
  self.throwing = false
  self.lasso = {}
  self.lasso.x = 0
  self.lasso.y = 0
  self.lasso.dirx = 0
  self.lasso.diry = 0
  self.arena = a
  bulls = b
  self.cb = c
  love.graphics.setLineWidth(3)
  if not walkAnim then
    walkAnim = newAnimation(images.playerwalkanimation, 58, 64, 0.1, 16)
    walkAnim:play()
  end
  if not spinAnim then
    spinAnim = newAnimation(images.playerspinning, 55, 64, 0.1, 16)
    spinAnim:play()
  end
end

function player:mousepressed(x, y, button)
  if button == "l" then
    if self.gripping then
      self.gripping = false
      bulls[self.gripped].caught = false
      self.cb(false)
    else
      self.spinning = true
    end
  end
end

function player:mousereleased(x, y, button)
  if button == "l" then
    if self.spinning then
      self.spinning = false
      self.throwing = true
      self.lasso.x = self.x
      self.lasso.y = self.y
      self.lasso.dirx = math.cos(self.r-0.5*math.pi)
      self.lasso.diry = math.sin(self.r-0.5*math.pi)
    end
  end
end

function player:update(dt)
  walkAnim:update(dt)
  spinAnim:update(dt)
  local x, y = love.mouse.getPosition()
  self.r = math.atan2(y-300, x-400)+0.5*math.pi
  self.lassor = self.lassor + lassospeed*dt
  x = (getkey("right") and 1 or 0) - (getkey("left") and 1 or 0)
  y = (getkey("down") and 1 or 0) - (getkey("up") and 1 or 0)
  self.x = self.x + x*speed*dt
  self.y = self.y + y*speed*dt
  self.moving = (x ~= 0 or y ~= 0)

  --constrain to arena
  self.x = math.max(self.x, self.arena:left()+25)
  self.x = math.min(self.x, self.arena:right()-25)
  self.y = math.max(self.y, self.arena:top()+25)
  self.y = math.min(self.y, self.arena:bottom()-25)

  if self.throwing then
    self.lasso.x = self.lasso.x + self.lasso.dirx*lassothrowspeed
    self.lasso.y = self.lasso.y + self.lasso.diry*lassothrowspeed
    
    local lassobox = { { x=self.lasso.x-37, y=self.lasso.y-37 },  { x=self.lasso.x+37, y=self.lasso.y-37 }, { x=self.lasso.x+37, y=self.lasso.y+37 }, { x=self.lasso.x-37, y=self.lasso.y+37 } }
    for i, bull in ipairs(bulls) do
      if quadsColliding(lassobox, rotatebox(bull:getbodybox())) or quadsColliding(lassobox, rotatebox(bull:getheadbox())) then
        self.throwing = false
        soundmanager:play(sounds.yeehaw)
        self.gripping = true
        self.gripped = i
        bulls[i].caught = self
        self.cb(true)
      end
    end
    
    if (self.x - self.lasso.x)^2 + (self.y - self.lasso.y)^2 > ropelengthSq then
      self.throwing = false;
    end
  end
  
  if self.gripping then
    local bull = bulls[self.gripped]
    if not bull then self.gripping = false return end
    local angle = math.atan2(self.y-bull.y, self.x-bull.x)-0.5*math.pi
    self.r = angle
    local dist = (self.x - bull.x)^2 + (self.y - bull.y)^2
    if dist > ropelengthSq then
      local ropeangle = math.atan2(bull.y-self.y, bull.x-self.x)
      bull.x = self.x + ropelength*math.cos(ropeangle);
      bull.y = self.y + ropelength*math.sin(ropeangle);
    end
  end
end

function player:center()
  love.graphics.translate(400-self.x, 300-self.y)
end

function player:draw()
  if not self.moving or self.gripping then
    local img = images.hat
    if self.gripping then img = images.hat_gripping end
    if self.spinning or self.throwing then img = images.hat_spinning end
    love.graphics.draw(img, self.x, self.y, self.r, 1, 1, 25, 25)
  else
    local anim = walkAnim
    if self.spinning or self.throwing then anim = spinAnim end
    anim:draw(self.x, self.y, self.r, 1, 1, 25, 25)
  end
  if self.spinning then
    local x, y = math.cos(self.r-0.6)*30, math.sin(self.r-0.6)*30
    love.graphics.draw(images.lasso, self.x+x, self.y+y, self.lassor, 1, 1, 12, 12)
  elseif self.gripping then
    local bull = bulls[self.gripped]
    if not bull then self.gripping = false return end
    local x, y = math.cos(self.r-0.5*math.pi)*23, math.sin(self.r-0.5*math.pi)*23
    love.graphics.setColor(104, 89, 67)
    love.graphics.line(self.x+x, self.y+y, bull.x, bull.y)
    love.graphics.setColor(255, 255, 255)
  end
  if self.throwing then
    local dist = math.sqrt((self.x-self.lasso.x)^2 + (self.y-self.lasso.y)^2)
    local angle = math.atan2(self.lasso.y-self.y, self.lasso.x-self.x)
    dist = dist - 37
    local x, y = math.cos(self.r-0.6)*30, math.sin(self.r-0.6)*30
    local tx = math.cos(angle)*dist
    local ty = math.sin(angle)*dist
    love.graphics.setColor(104, 89, 67)
    love.graphics.line(self.x+x,self.y+y, self.x+tx, self.y+ty)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.lasso, self.lasso.x, self.lasso.y, 0, 1, 1, 37, 37)
  end
end

function player:gethitbox()
  if self.moving then
    return { x = self.x-15, y = self.y-15, w = 40, h = 40, r = self.r, ox = 15, oy = 15 }
  else
    return { x = self.x-20, y = self.y-20, w = 40, h = 40, r = self.r, ox = 20, oy = 20 }
  end
end
