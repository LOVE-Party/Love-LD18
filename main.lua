require("gamestate")
require("utils")
require("soundmanager")

--states requires
require("states/intro")
require("states/menu")
require("states/game")

--classes requires
require("player")

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  
  images = {}
  loadfromdir(images, "gfx", "png", love.graphics.newImage)
  
  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)
  
  Gamestate.registerEvents()
  if arg[2] and arg[2] == "--no-intro" then
    Gamestate.switch(Gamestate.game)
  else
    Gamestate.switch(Gamestate.intro)
  end
end
