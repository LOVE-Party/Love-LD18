Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player

function state:enter()
  player = _G.player:new(400, 300)
end

function state:update(dt)
  player:update(dt)
end

function state:draw()
  love.graphics.printf("Wee, a game!", 0, 300, 800, "center")
  player:draw()
end
