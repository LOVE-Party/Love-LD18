Gamestate.game = Gamestate.new()
local state = Gamestate.game

function state:enter()
	love.graphics.printf("Wee, a game!", 0, 300, 800, "center")
end
