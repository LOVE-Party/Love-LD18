
function love.conf(t)
	t.title    = "Ludum Dare 18 — Enemies as weapons"
	t.author   = "LOVE Party"
	t.version  = 62
	t.console  = false
	t.identity = "lparty-ld18"

	t.screen.width      = 800
	t.screen.height     = 600
	t.screen.fullscreen	= false
	t.screen.vsync			= true
	t.screen.fsaa       = 0

	t.modules.joystick = true
	t.modules.audio    = true
	t.modules.keyboard = true
	t.modules.event    = true
	t.modules.image    = true
	t.modules.graphics = true
	t.modules.timer    = true
	t.modules.mouse    = true
	t.modules.sound    = true
	t.modules.physics  = true
end

