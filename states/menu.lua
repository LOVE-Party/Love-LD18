
-- takes an xy coord, and parms suitable for string.format (which includes a plain string)
-- the result of the format call is then centered horizontally on the given position, and
-- printed in the current color and font
local function centerPrint(x, y, ...)
	local lg = love.graphics
	local text = string.format(...)
	local font = lg.getFont();
	x = x - (font:getWidth(text)/2)
	lg.print(text, x, y);
end

hook.add("draw", function()
	local lg = love.graphics
	lg.setFont(12)
	scrw = lg.getWidth()
	offw = scrw / 2
	local font = lg.getFont();
	inc_lh = font:getLineHeight() * font:getHeight()
	centerPrint(offw, inc_lh * 10,   "<Title>"   )
	centerPrint(offw, inc_lh * 13,   "Play"      )
	centerPrint(offw, inc_lh * 14,   "Credits"   )
	centerPrint(offw, inc_lh * 15,   "Options"   )
	centerPrint(offw, inc_lh * 17,   "Quit"      )
end, "draw-menu", "menu")

hook.add("mr", function(b, c, d) -- f-ed if I know what they are, i'm just reading from ualove.init
	local lg = love.graphics
	lg.setFont(12)
	scrw = lg.getWidth()
	offw = scrw / 2
	local font = lg.getFont();
	inc_lh = font:getLineHeight() * font:getHeight()
	centerPrint(offw, inc_lh * 10,   "<Title>"   )
	centerPrint(offw, inc_lh * 13,   "Play"      )
	centerPrint(offw, inc_lh * 14,   "Credits"   )
	centerPrint(offw, inc_lh * 15,   "Options"   )
	centerPrint(offw, inc_lh * 17,   "Quit"      )
end, "mr-menu", "menu")
