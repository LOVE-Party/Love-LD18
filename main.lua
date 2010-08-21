
require "ui.screen"

local active -- = love.filesystem.load("scr_blank.lua")()


function setActiveScreen(scr)
  assert(scr)
  if(type(scr) == 'string') then scr = screen.load(scr) end
  active = scr
end

function love.load()
	active = screen.load("scr_main")
	love.graphics.setFont(love._vera_ttf, 22)
end

function love.update(dt)
	active:update(dt)
end

function love.draw()
	active:draw()
end

function love.mousereleased(x, y, btn)
	active:mousereleased(x, y, btn)
end

