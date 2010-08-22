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

local function boxtocircle(b)
	local circle = {}
	circle.x = (b.x + b.w) / 2
	circle.y = (b.y + b.h) / 2
	circle.r = math.sqrt((b.h^2) + (b.w^2))
	return circle
end

function CircleCircleCollision(a, b)
	local t_radius = a.r + b.r
	      t_radius = math.sqrt(t_radius)
	local t_distance = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
	
	print("distance:", t_distance, "radius", t_radius)
	
	return t_distance < t_radius
end

local function arraytobox(a)
	return {x=a[1], y=a[2], w=a[1]+a[3], h=a[2]+a[4], r=a[5]}
end

function BoxBoxCollision(a, b)
	a = arraytobox(a)
	b = arraytobox(b)
	
	return CircleCircleCollision(boxtocircle(a), boxtocircle(b))
	
end
