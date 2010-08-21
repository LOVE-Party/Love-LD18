
return screen.newMenu {
layout =	{
				{y =   0, x =   0, w = 1024, h = 640, nohighlight = true,
					img = screen.loadImage("background")};
					
				{y =  25, x = 320, w = 130, h =  50, text = "LD18 -- Enemies as Weapons!",
					isLabel = true, nohighlight = true};
				
				{y = 100, x = 320, w = 130, h =  50, text = "Play", 
					activate = function() --[[ start game --]] end};
				{y = 150, x = 320, w = 130, h =  50, text = "Credits",
					activate = function() setActiveScreen("scr_credits") end};
				{y = 200, x = 320, w = 130, h =  50, text = "Options"};
				{y = 450, x = 320, w = 130, h =  50, text = "Quit",
					activate = function() love.event.push('q') end};
			}
}

