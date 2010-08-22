require "lib/SECS"
require "lib/AnAL"

local speed = 200
local capturedspeed = 600
local normalAnim
local caughtAnim

bull = class:new()

function bull:init(x, y, a, p)
  self.x = x or 0
  self.y = y or 0
  self.dir = math.random() * math.pi
  self.dirX = math.cos(self.dir)
  self.dirY = math.sin(self.dir)
  self.dur = math.random(1,3)
  self.r = 0
  self.caught = false
  self.arena = a
  self.player = p
  self.hitwall = false
  if not normalAnim then
    normalAnim = newAnimation(images.bulls, 76, 167, 0.1, 8)
    normalAnim:play()
  end
  if not caughtAnim then
    caughtAnim = newAnimation(images.bulls_caught, 76, 167, 0.1, 8)
    caughtAnim:play()
  end
  self.dustParticles = love.graphics.newParticleSystem(images.dust, 25)
  self.dustParticles:setSpeed(2, 7)
  self.dustParticles:setPosition(self.x, self.y)
  self.dustParticles:setDirection(self.r+math.pi)
  self.dustParticles:setLifetime(-1)
  self.dustParticles:setEmissionRate(6)
  self.dustParticles:setParticleLife(1.50)
  self.dustParticles:setSpin(0.1, 1.0, 1)
  self.dustParticles:setColor(255, 255, 255, 255, 255, 255, 255, 0)
  self.dustParticles:start()
end

function bull:update(dt)
  self.dur = self.dur - dt
  normalAnim:update(dt)
  caughtAnim:update(dt)
  self.dustParticles:update(dt)
  
  if not self.caught then
    if self.dur <= 0 or self.hitwall then
      local x, y, r
      if math.random(1, 7) > 4 then
        x, y = self.arena:center()
	r = math.atan2(y-self.y, x-self.x)
        self.dir = r + (math.random()-0.5)*math.pi
      else
        x, y = self.player.x, self.player.y
	r = math.atan2(y-self.y, x-self.x)
	self.dir = r + 0.05*math.random()
      end
      self.dirX = math.cos(self.dir)
      self.dirY = math.sin(self.dir)
      self.dur = math.random(3,7)
      self.hitwall = false
    end
  
    self.x = self.x + self.dirX*speed*dt
    self.y = self.y + self.dirY*speed*dt
    self.r = self.dir + (math.pi * 0.5)
  else
    self.dur = 1
    local p = self.caught
    self.dir = math.atan2(p.y-self.y, p.x-self.x)+0.5*math.pi
    self.dirX, self.dirY = math.cos(self.dir), math.sin(self.dir)

    self.x = self.x + self.dirX*capturedspeed*dt
    self.y = self.y + self.dirY*capturedspeed*dt
    self.r = self.dir+0.5*math.pi
  end

  local x, y = self.x, self.y
  --constrain to arena
  self.x = math.max(self.x, self.arena:left()+38)
  self.x = math.min(self.x, self.arena:right()-38)
  self.y = math.max(self.y, self.arena:top()+70)
  self.y = math.min(self.y, self.arena:bottom()-70)
  self.dustParticles:setPosition(self.x, self.y)
  self.dustParticles:setDirection(self.r+math.pi)
  if self.x ~= x or self.y ~= y then
    --we ran into a wall
    self.hitwall = true
    --player loses control now
    if self.caught then
      self.caught.gripping = false
      self.caught = false 
    end
  end
end

function bull:draw()
  local anim = normalAnim
  if self.caught then anim = caughtAnim end
  love.graphics.draw(self.dustParticles, 0, 0)
  anim:draw(self.x, self.y, self.r, 1, 1, 25, 25)
end
