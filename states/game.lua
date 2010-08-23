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
local score
local combo
local combotimer
local blood

local function caughtcb(caught)
  if caught then combotimer = 0
  else combo = 0
  end
end

local function createblood(x, y, amount, speedMin, speedMax)
  local p = love.graphics.newParticleSystem(images.bloodparticle, 100)
  p:setSpread(2*math.pi)
  p:setSize(0.8, 1.5, 1)
  p:setParticleLife(1)
  p:setLifetime(0.2)
  p:setPosition(x, y)
  p:setSpeed(speedMin, speedMax)
  p:setEmissionRate(amount)
  p:setColor(255, 255, 255, 255, 255, 255, 255, 0)
  p:start()
  table.insert(blood, p)
end

function state:enter()
  bulls = {}
  spawnlist = {}
  gorelist = {}
  timer = 9
  health = 3
  score = 0
  combo = 0
  combotimer = 0
  blood = {}
  invuln = false
  love.graphics.setBackgroundColor(236,227,200)
  arena = _G.arena:new(0,0,1408,1408)
  player = _G.player:new(400, 300, arena, bulls, caughtcb)
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
  timer = timer + dt + combo*dt
  if timer > 9 then
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
    v.bull.dustParticles:update(dt)
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
  if player.gripping then
    combotimer = combotimer + dt
    if combotimer > 8 then
      combo = 0
      bulls[player.gripped].caught = false
      player.gripping = false
      combo = 0
    end
  end
  local removelist = {}
  for i, v in ipairs(blood) do
    v:update(dt)
    if not v:isActive() and v:count() == 0 then
      table.remove(removelist, i)
    end
  end
  for i, v in ipairs(removelist) do
    table.remove(blood, v-i+1)
  end
  --collisions!
  local caughtbull = player.gripping
  if caughtbull then
    caughtbull = bulls[player.gripped]
  end
  local removelist = {}
  for i, v in ipairs(bulls) do
    if not v.caught and quadsColliding(rotatebox(v:getheadbox()), rotatebox(player:gethitbox())) and not invuln then
      --OH GOD WE COLLIDE!
      soundmanager:play(sounds.ow)
      health = health - 1
      if player.gripping then
        bulls[player.gripped].caught = false
        player.gripping = false
        combo = 0
      end
      v.dur = 3
      v.dir = v.dir+math.pi
      v.dirX = math.cos(v.dir)
      v.dirY = math.sin(v.dir)
      v.r = v.r+math.pi
      invuln = 1
      createblood(player.x, player.y, 75, 50, 120)
    elseif not v.caught and caughtbull and caughtbull ~= v and (quadsColliding(rotatebox(caughtbull:getheadbox()), rotatebox(v:getheadbox())) or quadsColliding(rotatebox(caughtbull:getheadbox()), rotatebox(v:getbodybox()))) then
      combo = combo + 1
      combotimer = 0
      score = score + 100*combo
      soundmanager:play(sounds.splat)
      table.insert(removelist, i)
      table.insert(gorelist, {bull = v, timer = 0, alpha = 255, combo = combo})
      createblood(v.x, v.y, 100, 150, 300)
      v.dustParticles:stop()
    end
  end
  for i, v in ipairs(removelist) do
    table.remove(bulls, v-i+1)
    if player.gripping and (v-i+1) < player.gripped then
      player.gripped = player.gripped - 1
    end
  end
  if health <= 0 then
    Gamestate.switch(Gamestate.lost, score)
  end
end

function state:draw()
  love.graphics.push()
  player:center()
  arena:draw()
  for i, v in ipairs(gorelist) do
    love.graphics.setColor(255, 255, 255, v.alpha)
    love.graphics.draw(v.bull.dustParticles, 0, 0)
    love.graphics.draw(images.gore, v.bull.x, v.bull.y, v.bull.r, 1, 1, 25, 25)
    love.graphics.printf(v.combo .. "X", v.bull.x-30, v.bull.y-10-10*(255/v.alpha), 60, "center")
  end
  love.graphics.setColor(255, 255, 255, 255)
  for _, bull in ipairs(bulls) do
    bull:draw()
  end
  if invuln then love.graphics.setColor(255, 255, 255, 255-(150*invuln)) end
  player:draw()
  if invuln then love.graphics.setColor(255, 255, 255, 255) end
  for i, v in ipairs(blood) do
    love.graphics.draw(v, 0, 0)
  end
  love.graphics.pop()
  --draw hud
  minimap:draw()
  for i = 1, 3 do
    love.graphics.draw(health >= i and images.fullheart or images.emptyheart, 14*i, 14)
  end
  love.graphics.draw(images.comboicon, 14, 85)
  love.graphics.setColor(50,50,50)
  love.graphics.setFont(guifont)
  love.graphics.print("Score: "..score, 14, 72)
  love.graphics.print("x "..combo, 55, 108)
end

function state:keypressed(key, unicode)
  if key == "rctrl" then
    debug.debug()
  elseif key == "escape" then
    Gamestate.switch(Gamestate.menu)
  end
end
