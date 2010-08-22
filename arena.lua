require "SECS"

arena = class:new()

function arena:init(x, y, w, h)

	self.width = w or 1024;
	self.height = h or 1024;
	self.x = x or 0;
	self.y = y or 0;
	
end

function arena:update(dt)

	--probably spawn bulls here!

end

function arena:left()
	
	return ( self.x + 128 );
	
end

function arena:right()
	
	return ( self.width - 128 );
	
end

function arena:top()
	
	return ( self.y + 128 );
	
end

function arena:bottom()
	
	return ( self.height - 128 );
	
end

function arena:draw()
	
	--draw top walls
	for i = 128, self.width-256, 256 do
	
		love.graphics.draw( images.walltiles.top2, i, self.y );
		
	end
	
	--draw left walls
	for i = 128, self.height-256, 256 do
	
		love.graphics.draw( images.walltiles.left2, self.x, i );
		
	end
	--draw right walls
	for i = 128, self.height-256, 256 do
	
		love.graphics.draw( images.walltiles.right2, self.x+self.width-128, i );
		
	end
	--draw bottom walls
	for i = 128, self.width-256, 256 do
	
		love.graphics.draw( images.walltiles.bottom2, i, self.y+self.height-128 );
		
	end
	
	--draw corners
	love.graphics.draw( images.walltiles.topleft2, self.x, self.y );
	love.graphics.draw( images.walltiles.topright2, self.width-128, self.y );
	love.graphics.draw( images.walltiles.bottomleft2, self.x, self.height-128 );
	love.graphics.draw( images.walltiles.bottomright2, self.width-128, self.height-128 );
	
end
