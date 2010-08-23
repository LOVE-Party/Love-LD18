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

local function rotatebox(a)
  local quad = {{},{},{},{}}
  quad[1].x = a.x
  quad[1].y = a.y
  quad[2].x = a.x+a.w
  quad[2].y = a.y
  quad[3].x = a.x+a.w
  quad[3].y = a.y+a.h
  quad[4].x = a.x
  quad[4].y = a.y+a.h
  local x, y = a.x+a.ox, a.y+a.oy
  for i = 1, 4 do
    local dist = (quad[i].x-x)^2+(quad[i].y-y)^2
    local angle = math.atan2(quad[i].y-y, quad[i].x-x)
    angle = angle + a.r
    quad[i].x = math.cos(angle)*dist+x
    quad[i].y = math.sin(angle)*dist+y
  end
  return quad
end

local function boxtocircle(b)
	local circle = {}
	circle.x = (b.x + b.w) / 2
	circle.y = (b.y + b.h) / 2
	circle.r = math.sqrt((b.h^2) + (b.w^2))
	return circle
end

function CircleCircleCollision(a, b)
	local t_radius = math.sqrt(a.r + b.r)
	local t_distance = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
	
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
