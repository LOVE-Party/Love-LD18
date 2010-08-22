require "lib/SECS"

minimap = class:new()

function minimap:init(p,a,b)
  self.width = 180
  self.height = 180
  self.x = 600
  self.y = 400
  self.player = p
  self.arena = a
  self.bulls = b
  
  self.xratio = a.width/self.width
  self.yratio = a.height/self.height
end

function minimap:update(dt)

end

function minimap:draw()
  --draw minimap bg
  love.graphics.draw(images.minimap, self.x, self.y)
  --draw bulls
  for _, bull in ipairs(self.bulls) do
    local xPos = self.x + (bull.x - self.arena.x) / self.xratio;
    local yPos = self.y + (bull.y - self.arena.y) / self.yratio;
    love.graphics.draw(images.bull_icon, xPos, yPos)
  end
  --draw player
  local xPos = self.x + (self.player.x - self.arena.x) / self.xratio;
  local yPos = self.y + (self.player.y - self.arena.y) / self.yratio;
  love.graphics.draw(images.cowboy_icon, xPos, yPos)
end
