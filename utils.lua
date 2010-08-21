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
