------------------------------------------------------------------------
-- Screen utility functions
------------------------------------------------------------------------
--
-- @author: DMB
-- @date: 9feb2010
-- @licence: Private
------------------------------------------------------------------------

screen = {}

local lg = love.graphics

function screen.bbox(x1, y1, x2, y2, w, h)
	return ((x1 >= x2)   and (y1 >= y2) 
	   and  (x1 <= x2+w) and (y1 <= y2+h))
end


function screen.load(resname)
	assert(resname and type(resname) == 'string')
	local resource = love.filesystem.load("scr/" .. resname .. ".lua")
	return resource()
end

function screen.loadImage(imgname)
	return love.graphics.newImage("imgs/" .. imgname .. ".png")
end

function screen.drawElement(e)
	local font = love.graphics.getFont()
	local fh = font:getHeight()* font:getLineHeight()
	lg.setColor(255, 255, 255, (e.active or e.nohighlight) and 255 or 127)
	if not e.isLabel then
		lg.setColor(127, 127, 127, 127)
		lg.rectangle("fill", e.x, e.y, e.w, e.h)
		lg.setColor(255, 255, 255, (e.active or e.nohighlight) and 255 or 127)
		lg.rectangle("line", e.x, e.y, e.w, e.h)
	end
	if e.text then 
		local fw = font:getWidth(e.text)

		lg.print(e.text, e.x+(e.w/2)-(fw/2), e.y+fh)
	end
	if e.img then
		lg.draw(e.img, e.x, e.y, 0, 
				math.min(e.w/e.img:getWidth(), e.h/e.img:getHeight() ))	end

end


function screen.newMenu(t)
	assert((not t) or type(t) == 'table')
	local m = t or{}
	t.draw = t.draw or function(self, dt)
		for k, v in ipairs(self.layout) do
			screen.drawElement(v);
		end
	end
	
	t.update = t.update or function(self, dt)
		local m = love.mouse
		for k, v in pairs(self.layout) do
			v.active = screen.bbox(m.getX(), m.getY(), v.x, v.y, v.w, v.h)
		end
	end

	t.mousereleased = t.mousereleased or function(self, x,y,btn)
		for k, v in ipairs(self.layout) do
			if (not v.isLabel) and screen.bbox(x, y, v.x, v.y, v.w, v.h) and v.activate then
				v.activate()
				break
			end
		end
	end
	
	return m
end
