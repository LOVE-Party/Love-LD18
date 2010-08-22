Gamestate.lost = Gamestate.new()
local state = Gamestate.lost

local font
local largefont

function state:enter()
  if not font then font = love.graphics.getFont() end
  if not largefont then largefont = love.graphics.newFont("fonts/Chunkfive.otf", 48) end
end

function state:update(dt)
  soundmanager:update(dt)
end

function state:draw()
  love.graphics.draw(images.deadplayer, 400, 300, 0, 1, 1, 42, 85)
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(largefont)
  love.graphics.printf("Splat!", 300, 300, 200, "center")
  love.graphics.setFont(font)
  love.graphics.printf("Awww, you died, good thing you can just restart then.", 300, 400, 200, "center")
  love.graphics.setColor(255, 255, 255)
end
