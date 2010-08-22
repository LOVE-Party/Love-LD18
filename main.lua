require("lib/gamestate")
require("utils")
require("lib/soundmanager")

--states requires
require("states/intro")
require("states/menu")
require("states/game")
require("states/lost")

--classes requires
require("player")
require("bull")
require("arena")
require("minimap")

local font

function love.load()
  love.graphics.setBackgroundColor(50, 50, 50)
  love.graphics.setCaption("Fistful of Beef")

  --Set Random Seed
  math.randomseed(os.time());
  math.random()
  math.random()
  math.random()

  images = {}
  loadfromdir(images, "gfx", "png", love.graphics.newImage)

  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)

  music = {}
  loadfromdir(music, "music", "ogg", love.audio.newSource)

  font = love.graphics.newFont("fonts/Chunkfive.otf")
  love.graphics.setFont(font)

  Gamestate.registerEvents()
  Gamestate.switch(Gamestate[(arg[2] and arg[2]:match("--state=(.+)") or "intro")])
end
