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

function BoxBoxCollision(a, b)
	a = {x=a[1], y=a[2], x2=a[1]+a[3], y2=a[2]+a[4]}
	b = {x=b[1], y=b[2], x2=b[1]+b[3], y2=b[2]+b[4]}
	
	return (a.x >= b.x and a.x <= b.x2) and (a.y >= b.y and a.y <= b.y2) or
	       (a.x2 >= b.x2 and a.x2 <= b.x) and (a.y2 >= b.y2 and a.y2 <= b.y)
end
