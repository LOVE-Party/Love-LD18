Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local arena
local bulls
local minimap
local timer
local spawnlist
local health

function state:enter()
  bulls = {}
  spawnlist = {}
  timer = 15
  health = 3
  love.graphics.setBackgroundColor(236,227,200)
  arena = _G.arena:new(0,0,1408,1408)
  player = _G.player:new(400, 300, arena, bulls)
  minimap = _G.minimap:new(player, arena, bulls, spawnlist)
  soundmanager:playMusic(music.vestapol, music.struttin_rag)
end

function state:mousepressed(x, y, button)
  player:mousepressed(x, y, button)
end

function state:mousereleased(x, y, button)
  player:mousereleased(x, y, button)
end

function state:update(dt)
  soundmanager:update(dt)
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
  --collisions!
  local playerhitbox = {player.x-25, player.y-13, 50, 30}
  local removelist = {}
  for i, v in ipairs(bulls) do
    if BoxBoxCollision(v.x-25, v.y-25, 75, 135, unpack(playerhitbox)) then
      --OH GOD WE COLLIDE!
      health = health - 1
      table.insert(removelist, i)
    end
  end
  for i, v in ipairs(removelist) do
    table.remove(bulls, v-i+1)
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
  for i = 1, 3 do
    love.graphics.draw(health >= i and images.fullheart or images.emptyheart, 14*i, 14)
  end
end

function state:keypressed(key, unicode)
  if key == "rctrl" then
    debug.debug()
  end
end
