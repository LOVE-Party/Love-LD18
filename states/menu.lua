Gamestate.menu = Gamestate.new()
local state = Gamestate.menu

local font
local titlefont
local subtitlefont
local menufont
local submenufont

function state:enter()
  if not font then font = love.graphics.getFont() end
  if not titlefont then titlefont = love.graphics.newFont("fonts/burnstown_dam.otf", 110) end
  if not subtitlefont then subtitlefont = love.graphics.newFont("fonts/Chunkfive.otf", 32) end
  if not menufont then menufont = love.graphics.newFont("fonts/Chunkfive.otf", 24) end
  if not submenufont then submenufont = love.graphics.newFont("fonts/Chunkfive.otf", 16) end
  love.graphics.setBackgroundColor(236,227,200)
  
  soundmanager:playMusic(music.struttin_rag)
end

function state:leave()
  love.audio.stop()
end

function state:update(dt)
  soundmanager:update(dt)
end

function state:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(images.menucow, -200, 250)
  
  love.graphics.setColor(30, 30, 30)
  love.graphics.setFont(titlefont)
  love.graphics.print("Fistful of Beef", 70, 175)
  love.graphics.setFont(subtitlefont)
  love.graphics.print("Courtesy of the LOVE-PARTY", 88, 210)
  love.graphics.setFont(menufont)
  love.graphics.print("CONTROLS", 400-menufont:getWidth("CONTROLS")/2, 325)
  love.graphics.setFont(submenufont)
  love.graphics.print("Movement:", 250, 350)
  love.graphics.print("Swing lasso:", 250, 370)
  love.graphics.print("Throw rope:", 250, 390)
  love.graphics.print("Release bull:", 250, 410)
  love.graphics.print("WASD / Arrow keys", 390, 350)
  love.graphics.print("Hold left mouse button", 390, 370)
  love.graphics.print("Release mouse button", 390, 390)
  love.graphics.print("Single click", 390, 410)
  
  love.graphics.setFont(subtitlefont)
  love.graphics.print("Press ENTER to play!", 400-subtitlefont:getWidth("Press ENTER to play!")/2, 500)
end

function state:keypressed(key, unicode)
  if key == "return" then
    Gamestate.switch(Gamestate.game)
  elseif key == "escape" then
    love.event.push('q')
  end
end
