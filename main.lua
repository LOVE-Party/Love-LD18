require("gamestate")
require("utils")
require("soundmanager")

require("intro")

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  
  images = {}
  loadfromdir(images, "imgs", "png", love.graphics.newImage)
  
  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)
  
  Gamestate.registerEvents()
	Gamestate.switch(Gamestate.intro)
end
