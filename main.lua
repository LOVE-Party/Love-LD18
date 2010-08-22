require("lib/gamestate")
require("utils")
require("lib/soundmanager")

--states requires
require("states/intro")
require("states/menu")
require("states/game")

--classes requires
require("player")
require("bull")
require("arena")

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setCaption("Fistful of Beef")
  
  images = {}
  loadfromdir(images, "gfx", "png", love.graphics.newImage)
  
  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)
  
  Gamestate.registerEvents()
  local startstate = "intro"
  if arg[2] then
    startstate = arg[2]:match("--state=(.+)") or startstate
  end
  Gamestate.switch(Gamestate[startstate])
end
