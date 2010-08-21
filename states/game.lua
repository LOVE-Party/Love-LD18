Gamestate.game = Gamestate.new()
local state = Gamestate.game

function state:draw()
	love.graphics.printf("Wee, a game!", 0, 300, 800, "center")
end
