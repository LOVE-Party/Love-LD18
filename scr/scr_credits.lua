
return screen.newMenu {
layout =	{
				{y =   0, x =   0, w = 1024, h = 640, nohighlight = true,
					img = screen.loadImage("background")};
					
				{y =  25, x = 320, w = 130, h =  50, text = "LD18 -- Enemies as Weapons!",
					isLabel = true, nohighlight = true};
				
				{y = 100, x = 320, w = 130, h =  50, text = "thelinx", 
					isLabel = true, nohighlight = true};
				{y = 125, x = 320, w = 130, h =  50, text = "bartbes",
					isLabel = true, nohighlight = true};
				{y = 150, x = 320, w = 130, h =  50, text = "FelipeBudinich",
					isLabel = true, nohighlight = true};
				{y = 175, x = 320, w = 130, h =  50, text = "Nevon",
					isLabel = true, nohighlight = true};
				{y = 200, x = 320, w = 130, h =  50, text = "Roybie",
					isLabel = true, nohighlight = true};
				{y = 225, x = 320, w = 130, h =  50, text = "Textmode",
					isLabel = true, nohighlight = true};
				{y = 450, x = 320, w = 130, h =  50, text = "Back",
					activate = function() setActiveScreen("scr_main") end};
			}
}

