Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local arena
local bulls
local minimap
local timer
local spawnlist
local health
local gorelist
local invuln
local guifont

function state:enter()
  bulls = {}
  spawnlist = {}
  gorelist = {}
  timer = 15
  health = 3
  invuln = false
  love.graphics.setBackgroundColor(236,227,200)
  arena = _G.arena:new(0,0,1408,1408)
  player = _G.player:new(400, 300, arena, bulls)
  minimap = _G.minimap:new(player, arena, bulls, spawnlist)
  soundmanager:playMusic(music.vestapol)
  if not guifont then guifont = love.graphics.newFont("fonts/Chunkfive.otf", 24) end
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
    table.insert(spawnlist, {bull = bull:new(x, y, arena, player), gate = gate})
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
  removelist = {}
  for i, v in ipairs(gorelist) do
    v.timer = v.timer + dt
    v.alpha = 255*(5-v.timer)/5
    if v.timer > 5 then
       table.insert(removelist, i)
    end
  end
  for i, v in ipairs(removelist) do
    table.remove(gorelist, v-i+1)
  end
  if invuln then
    invuln = invuln - dt
    if invuln < 0 then invuln = false end
  end
  --collisions!
  local playerhitbox = {player.x-25, player.y-13, 50, 30, player.r}
  local caughtbull = player.gripping
  local caughtbullhitbox = {0, 0, 75, 135, 0}
  if caughtbull then
    caughtbull = bulls[player.gripped]
    caughtbullhitbox[1] = caughtbull.x-25
    caughtbullhitbox[2] = caughtbull.y-25
    caughtbullhitbox[5] = caughtbull.r
  end
  local bullhitbox = {0, 0, 75, 135, 0}
  local removelist = {}
  for i, v in ipairs(bulls) do
    bullhitbox[1] = v.x-25
    bullhitbox[2] = v.y-25
    bullhitbox[5] = v.r
    if not v.caught and BoxBoxCollision(bullhitbox, playerhitbox) and not invuln then
      --OH GOD WE COLLIDE!
      soundmanager:play(sounds.ow)
      health = health - 1
      if player.gripping then
        bulls[player.gripped].caught = false
	player.gripping = false
      end
      v.dur = 3
      v.dir = v.dir+math.pi
      v.dirX = math.cos(v.dir)
      v.dirY = math.sin(v.dir)
      v.r = v.r+math.pi
      invuln = 1
    elseif not v.caught and caughtbull and BoxBoxCollision(bullhitbox, caughtbullhitbox) then
      table.insert(removelist, i)
      table.insert(gorelist, {bull = v, timer = 0, alpha = 255})
    end
  end
  for i, v in ipairs(removelist) do
    table.remove(bulls, v-i+1)
  end
  if health <= 0 then
    Gamestate.switch(Gamestate.lost)
  end
end

function state:draw()
  love.graphics.push()
  player:center()
  arena:draw()
  for i, v in ipairs(gorelist) do
    love.graphics.setColor(255, 255, 255, v.alpha)
    love.graphics.draw(images.gore, v.bull.x, v.bull.y, v.bull.r, 1, 1, 25, 25)
  end
  love.graphics.setColor(255, 255, 255, 255)
  for _, bull in ipairs(bulls) do
    bull:draw()
  end
  if invuln then love.graphics.setColor(255, 255, 255, 255-(150*invuln)) end
  player:draw()
  if invuln then love.graphics.setColor(255, 255, 255, 255) end
  love.graphics.pop()
  --draw hud
  minimap:draw()
  for i = 1, 3 do
    love.graphics.draw(health >= i and images.fullheart or images.emptyheart, 14*i, 14)
  end
  love.graphics.draw(images.comboicon, 14, 85)
  love.graphics.setColor(50,50,50)
  love.graphics.setFont(guifont)
  love.graphics.print("Score: 23451", 14, 72)
  love.graphics.print("x 8", 55, 108)
end

function state:keypressed(key, unicode)
  if key == "rctrl" then
    debug.debug()
  elseif key == "escape" then
    Gamestate.switch(Gamestate.menu)
  end
end
