require("ualove.init")

hook.add("initial", function()
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  love.filesystem.setIdentity("love-party.fob")
  love.graphics.setBackgroundColor(50, 50, 50)
  love.filesystem.load("states/intro.lua")()
  love.filesystem.load("states/menu.lua")()
  game.state = "i-peace"
end, "initial")
