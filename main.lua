require("gamestate")
require("utils")
require("soundmanager")

--states requires
require("states/intro")

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  
  images = {}
  loadfromdir(images, "gfx", "png", love.graphics.newImage)
  
  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)
  
  Gamestate.registerEvents()
	Gamestate.switch(Gamestate.intro)
end
