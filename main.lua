require("gamestate")
require("utils")

require("intro")

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  
  images = {}
  loadfromdir(images, "imgs", "png", love.graphics.newImage)
  
  Gamestate.registerEvents()
	Gamestate.switch(Gamestate.intro)
end
