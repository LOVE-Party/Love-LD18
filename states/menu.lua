Gamestate.menu = Gamestate.new()
local state = Gamestate.menu

function state:enter()
	Gamestate.switch(Gamestate.game)
end
