Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local bull
local arena

function state:enter()
  arena  = _G.arena:new(0,0,768,512)
  player = _G.player:new(400, 300, arena)
  bull   = _G.bull:new(400, 300, arena)
end

function state:update(dt)
  player:update(dt)
  bull:update(dt)
end

function state:draw()
  arena:draw()
  bull:draw()
  player:draw()
end

