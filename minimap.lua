require "lib/SECS"

minimap = class:new()

function minimap:init(p,a,b)
  self.width = 200
  self.height = 200
  self.x = 550
  self.y = 350
  self.player = p
  self.arena = a
  self.bulls = b
  
  self.xratio = a.width/self.width
  self.yratio = a.height/self.height
end

function minimap:update(dt)

end

function minimap:draw()
  love.graphics.setColor(255,255,255,100)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  --draw bulls
  love.graphics.setColor(255,0,0,100)
  for _, bull in ipairs(self.bulls) do
    local xPos = self.x + (bull.x - self.arena.x) / self.xratio;
    local yPos = self.y + (bull.y - self.arena.y) / self.yratio;
    love.graphics.circle("fill", xPos, yPos, 2)
  end
  love.graphics.setColor(0,0,255,100)
  local xPos = self.x + (self.player.x - self.arena.x) / self.xratio;
  local yPos = self.y + (self.player.y - self.arena.y) / self.yratio;
  love.graphics.circle("fill", xPos, yPos, 2)
  love.graphics.setColor(255,255,255)
end
