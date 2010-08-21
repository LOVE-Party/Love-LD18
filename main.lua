require("ualove.init")

hook.add("initial", function()
  love.graphics.setMode(800, 600, false, true, 0)
  love.graphics.setCaption("Fistful of Beef")
  love.filesystem.setIdentity("love-party.fob")
  love.graphics.setBackgroundColor(50, 50, 50)
  dofile("states/intro.lua")
  dofile("states/menu.lua")
  game.state = "i-peace"
end, "initial")
