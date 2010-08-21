--recursively load all files in the a dir and run them through a function
function loadfromdir(targettable, path, extension, func)
	local extmatch = "%." .. extension .. "$"
	for i, v in ipairs(love.filesystem.enumerate(path)) do
		if love.filesystem.isDirectory(path .. "/" .. v) then
			targettable[v] = {}
			loadfromdir(targettable[v], path .. "/" .. v, extension, func)
		elseif v:match(extmatch) then
			targettable[v:sub(1, -5)] = func(path .. "/" .. v)
		end
	end
end

function color(r, g, b, a)
	return {r or 0, g or 0, b or 0, a or 255}
end

function colortorgba(c)
	return unpack(c)
end

function round(n)
	return math.floor(n + 0.5)
end

function interpolate(n1, n2, degree)
	return (n2 - n1) * (degree or 0.5) + n1
end

function blendcolor(c1, c2, degree)
	local itp = interpolate
	return {itp(c1[1], c2[1], degree);
	        itp(c1[2], c2[2], degree);
	        itp(c1[3], c2[3], degree);
	        itp(c1[4], c2[4], degree);}
end

function time(t)
	local minute = t % 60
	local hour = (t - minute)/60
	     hour = hour % 24
	return math.floor(hour), math.floor(minute)
end

function epsilon(a, b, d)
	d = d or 0.0001
	return math.abs(a-b) < d
end

function nearenough(a, b, d)
	d = d or 0.1
	return epsilon(a.x, b.x, d) and epsilon(a.y, b.y, d)
end

function printf(...)
	return print(string.format(...))
end

function sign(x) return x < 0 and -1 or 1 end

--local function onlybetween ( stuff , x1 , y1 , x2 , y2 )
--	x1 = x1 % world.width
--	y1 = y1 % world.height
--	x2 = x2 % world.width
--	y2 = y2 % world.height
--	
--	local co = coroutine.create ( function ( ) 
--		for k , object in pairs ( stuff ) do
--			local ox , oy = object.x , object.y
--			if ( ox >= x1 and ox <= x2 or ox <= x1 and ox >= x2 ) 
--			    and ( oy >= y1 and oy <= y2 or oy <= y1 and oy >= y2 ) then
--				coroutine.yield ( object )
--			end
--		end
--	end )
--	return function ( )
--		local ok , res = coroutine.resume ( co )
--		return res
--	end 
--end

function onlybetween ( stuff , x1 , y1 , x2 , y2 )
	x1 = x1 % world.size
	x2 = x2 % world.size

	local co = coroutine.create ( function ( ) 
		for k , object in pairs ( stuff ) do
			local ox , oy = object.x , object.y
			if ( ox >= x1 and ox <= x2 or ox <= x1 and ox >= x2 ) 
			    and ( oy >= y1 and oy <= y2 ) then
				coroutine.yield ( object )
			end
		end
	end )
	return function ( )
		local ok , res = coroutine.resume ( co )
		return res
	end 
end

