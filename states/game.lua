Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local arena
local bulls
local minimap
local timer
local spawnlist

function state:enter()
  bulls = {}
  spawnlist = {}
  timer = 0
  love.graphics.setBackgroundColor(236,227,200)
  arena = _G.arena:new(0,0,1408,1408)
  player = _G.player:new(400, 300, arena, bulls)
  for i = 1, 1 do
    table.insert(bulls, bull:new(400, 300, arena))
  end
  minimap = _G.minimap:new(player, arena, bulls, spawnlist)
end

function state:mousepressed(x, y, button)
  player:mousepressed(x, y, button)
end

function state:mousereleased(x, y, button)
  player:mousereleased(x, y, button)
end

function state:update(dt)
  timer = timer + dt
  if timer > 15 then
    local gate = math.random(1, 4)
    local x, y = arena:center()
    if gate == 1 then y = arena:top()
    elseif gate == 2 then x = arena:left()
    elseif gate == 3 then x = arena:right()
    elseif gate == 4 then y = arena:bottom()
    end
    table.insert(spawnlist, {bull = bull:new(x, y, arena), gate = gate})
    arena:opengate(gate)
    timer = 0
  end
  local i = 1
  while spawnlist[i] do
    local v = spawnlist[i]
    if arena:gateopen(v.gate) then
      table.insert(bulls, v.bull)
      arena:closegate(v.gate)
      table.remove(spawnlist, i)
    else
      i = i + 1
    end
  end
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
  minimap:draw()
end

