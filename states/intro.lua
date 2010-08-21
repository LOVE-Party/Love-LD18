Gamestate.intro = Gamestate.new()
local state = Gamestate.intro

state.dt = 0;
state.played = {};

state.bombCue = 3;
state.explodeCue = 5;
state.yayCue = 6.6;
state.menuCue = 10;

function state:update( dt )

	soundmanager:update(dt);
	
	state.dt = state.dt + dt;
	
	if( state.dt >= 1 and not state.played.chirp ) then
		soundmanager:play( sounds.chirp );
		state.played.chirp = true;
	elseif( state.dt >= state.bombCue and not state.played.bombfall ) then
		soundmanager:play( sounds.bombfall );
		state.played.bombfall = true;
	elseif( state.dt >= state.explodeCue and not state.played.impact ) then
		soundmanager:play( sounds.impact );
		state.played.impact = true;
	elseif( state.dt >= state.yayCue and not state.played.yay ) then
		soundmanager:play( sounds.yay );
		state.played.yay = true;
	elseif( state.dt >= state.menuCue ) then
	
		Gamestate.switch(Gamestate.menu)
		
	end
	

end

function state:draw()

	if( state.played.impact ) then
		
		love.graphics.draw( images.gaycity, 7, 147);
		love.graphics.setColor(233, 233, 233, math.max(0, 255+((math.min(0, (state.dt-state.explodeCue)*-0.8)*510)/2)));
		love.graphics.rectangle("fill", 0, 0, 800, 600);
		love.graphics.setColor(255, 255, 255, 255);
		
	elseif( state.played.bombfall ) then
	
		love.graphics.draw(images.bg, 198, 224);
		love.graphics.draw(images.city, 243, 253);
		love.graphics.draw(images.bomb, 388, (state.dt-state.bombCue)*170-100);

	else
		
		love.graphics.draw(images.bg, 198, 224)
		love.graphics.draw(images.city, 243, 253)
  
	end

end

function state:keypressed( key, unicode )

	Gamestate.switch(Gamestate.menu)
	
end
