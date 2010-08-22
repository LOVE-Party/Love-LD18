require "lib/SECS"

local gates = {0, 0, 0, 0}
local gatedirs = {0, 0, 0, 0}
local gatespeed = 40

arena = class:new()

function arena:init(x, y, w, h)
  self.width = w or 1024
  self.height = h or 1024
  self.x = x or 0
  self.y = y or 0
end

function arena:opengate(g)
  local n
  if g == "top" then
    n = 1
  elseif g == "left" then
    n = 2
  elseif g == "right" then
    n = 3
  elseif g == "bottom" then
    n = 4
  end
  n = n or tonumber(g)
  if not n then return end
  gatedirs[n] = 1
end

function arena:closegate(g)
  local n
  if g == "top" then
    n = 1
  elseif g == "left" then
    n = 2
  elseif g == "right" then
    n = 3
  elseif g == "bottom" then
    n = 4
  end
  n = n or tonumber(g)
  if not n then return end
  gatedirs[n] = -1
end

function arena:gateopen(g)
  local n
  if g == "top" then
    n = 1
  elseif g == "left" then
    n = 2
  elseif g == "right" then
    n = 3
  elseif g == "bottom" then
    n = 4
  end
  n = n or tonumber(g)
  if not n then return end
  return gates[n] == 128
end

function arena:update(dt)
  for i, v in ipairs(gates) do
    gates[i] = math.max(math.min(v+gatedirs[i]*dt*gatespeed, 128), 0)
    if gates[i] == 0 or gates[i] == 128 then
      gatedirs[i] = 0
    end
  end
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

function arena:center()
  local x = (self.x + self.width) / 2
  local y = (self.y + self.height) / 2
  return x, y
end

function arena:draw()
  love.graphics.setColor(255,255,255)
  
  --draw top walls
  for i = 128, self.width-256, 256 do
    if i == 640 then
      love.graphics.draw(images.walltiles.gate, i+gates[1], self.y+110, math.rad(-90))
    elseif i < 640 then
      love.graphics.draw(images.walltiles.top, i, self.y+30)
    else
      love.graphics.draw(images.walltiles.top, i-128, self.y+30)
    end
  end
  
  --draw left walls
  for i = 128, self.height-256, 256 do
    if i == 640 then
      love.graphics.draw(images.walltiles.gate, self.x+60, i+gates[2])
    elseif i < 640 then
      love.graphics.draw(images.walltiles.left, self.x+30, i)
    else
      love.graphics.draw(images.walltiles.left, self.x+30, i-128)
    end
  end
  
  --draw right walls
  for i = 128, self.height-256, 256 do
    if i == 640 then
      love.graphics.draw(images.walltiles.gate, self.x+self.width-114, i+gates[3])
    elseif i < 640 then
      love.graphics.draw(images.walltiles.right, self.x+self.width-154, i)
    else
      love.graphics.draw(images.walltiles.right, self.x+self.width-154, i-128)
    end
  end
  
  --draw bottom walls
  for i = 128, self.width-256, 256 do
    if i == 640 then
      love.graphics.draw(images.walltiles.gate, i+128+gates[4], self.y+self.height-110, math.rad(90))
    elseif i < 640 then
      love.graphics.draw(images.walltiles.bottom, i, self.y+self.height-154)
    else
      love.graphics.draw(images.walltiles.bottom, i-128, self.y+self.height-154)
    end
  end
  
  --draw corners
  love.graphics.draw(images.walltiles.topleft, self.x+30, self.y+30)
  love.graphics.draw(images.walltiles.topright, self.width-128, self.y+30)
  love.graphics.draw(images.walltiles.bottomleft, self.x+30, self.height-128)
  love.graphics.draw(images.walltiles.bottomright, self.width-128, self.height-128)
end
