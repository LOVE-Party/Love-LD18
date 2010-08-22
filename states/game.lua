Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local arena

function state:enter()
  arena = _G.arena:new(0,0,768,512)
  player = _G.player:new(400, 300, arena)
end

function state:update(dt)
  player:update(dt)
end

function state:draw()
  love.graphics.printf("Wee, a game!", 0, 300, 800, "center")
  player:draw()
  arena:draw()
end
