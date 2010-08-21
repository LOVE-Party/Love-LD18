require "class"

cowboy = {}
	
function cowboy:new( x, y )

	cowboy = class:new();
	
	cowboy.x = x;
	cowboy.y = y;
	
	cowboy.velX = 0;
	cowboy.velY = 0;
	
	cowboy.image = nil; --cowboy image

	function cowboy:update( dt )
		
		self.x = self.x + self.velX;
		self.y = self.y + self.velY;
		
	end
	
	function cowboy:draw()
	
		love.draw( self.image, x, y );
	
	end
	
end
