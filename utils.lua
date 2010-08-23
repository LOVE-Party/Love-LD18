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

function rotatebox(a)
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
    local dist = math.sqrt((quad[i].x-x)^2+(quad[i].y-y)^2)
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

function isOnSegment(xi, yi, xj, yj, xk, yk)
    return (xi <= xk or xj <= xk) and (xk <= xi or xk <= xj) and (yi <= yk or yj <= yk) and (yk <= yi or xk <= yj)
end

function computeDirection(xi, yi, xj, yj, xk, yk)
    local a = (xk - xi) * (yj - yi)
    local b = (xj - xi) * (yk - yi)
    if a < b then return -1 elseif a > b then return 1 else return 0 end
end

function doLineSegmentsIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
    local d1 = computeDirection(x3, y3, x4, y4, x1, y1)
    local d2 = computeDirection(x3, y3, x4, y4, x2, y2)
    local d3 = computeDirection(x1, y1, x2, y2, x3, y3)
    local d4 = computeDirection(x1, y1, x2, y2, x4, y4)
    return (((d1 > 0 and d2 < 0) or (d1 < 0 and d2 > 0)) and 
        ((d3 > 0 and d4 < 0) or (d3 < 0 and d4 > 0))) or 
        (d1 == 0 and isOnSegment(x3, y3, x4, y4, x1, y1)) or 
        (d2 == 0 and isOnSegment(x3, y3, x4, y4, x2, y2)) or 
        (d3 == 0 and isOnSegment(x1, y1, x2, y2, x3, y3)) or 
        (d4 == 0 and isOnSegment(x1, y1, x2, y2, x4, y4))
end

function quadsColliding( a, b )
  for i=1,4 do
    local nextI = i+1
    if nextI == 5 then nextI = 1 end
    for j=1,4 do
      local nextJ = j+1
      if nextJ == 5 then nextJ = 1 end
      if doLineSegmentsIntersect(a[i].x, a[i].y, a[nextI].x, a[nextI].y, b[j].x, b[j].y, b[nextJ].x, b[nextJ].y) then
        return true
      end      
    end
  end
  return false
end
