Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local arena
local bulls = {}

function state:enter()
  love.graphics.setBackgroundColor(236,227,200)
  arena = _G.arena:new(0,0,1408,1408)
  player = _G.player:new(400, 300, arena, bulls)
  for i = 1, 1 do
    table.insert(bulls, bull:new(400, 300, arena))
  end
end

function state:mousepressed(x, y, button)
  player:mousepressed(x, y, button)
end

function state:mousereleased(x, y, button)
  player:mousereleased(x, y, button)
end

function state:update(dt)
  arena:update(dt)
  player:update(dt)
  for _, bull in ipairs(bulls) do
    bull:update(dt)
  end
end

function state:draw()
  love.graphics.push()
  player:center()
  arena:draw()
  for _, bull in ipairs(bulls) do
    bull:draw()
  end
  player:draw()
  love.graphics.pop()
  --draw hud
end

