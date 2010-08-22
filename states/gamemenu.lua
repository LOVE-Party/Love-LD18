Gamestate.intro = Gamestate.new()
local state = Gamestate.intro

function Gamestate.enter()
  Gamestate.switch(Gamestate.game)
end
