
function love.conf(t)
	t.title					= "Ludum Dare 18 — Enemies as weapons"	-- The title of the window the game is in (string)
	t.author					= "LOVE Party"									-- The author of the game (string)
	t.version				= 62												-- The L�VE version this game was made for (number)
	t.console				= false											-- Attach a console (boolean, Windows only)
	t.identity           = "ludumdare18"                        -- The identity used to determine where save data is stored.

	t.screen.width			= 1024											-- The window width (number)
	t.screen.height		= 640												-- The window height (number)
	t.screen.fullscreen	= false											-- Enable fullscreen (boolean)
	t.screen.vsync			= true											-- Enable vertical sync (boolean)
	t.screen.fsaa			= 2												-- The number of FSAA-buffers (number)

	t.modules.joystick	= true											-- Enable the joystick module (boolean)
	t.modules.audio		= true											-- Enable the audio module (boolean)
	t.modules.keyboard	= true											-- Enable the keyboard module (boolean)
	t.modules.event		= true											-- Enable the event module (boolean)
	t.modules.image		= true											-- Enable the image module (boolean)
	t.modules.graphics	= true											-- Enable the graphics module (boolean)
	t.modules.timer		= true											-- Enable the timer module (boolean)
	t.modules.mouse		= true											-- Enable the mouse module (boolean)
	t.modules.sound		= true											-- Enable the sound module (boolean)
	t.modules.physics		= true											-- Enable the physics module (boolean)
end

