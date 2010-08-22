Gamestate.lost = Gamestate.new()
local state = Gamestate.lost

function state:enter()
  love.graphics.setColor(0, 0, 0)
end

function state:draw()
  love.graphics.printf("YOU LOST", 300, 300, 200, "center")
end
