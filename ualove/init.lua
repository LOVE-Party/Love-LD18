game,hook = {state="",hooks={},debug=false,quit=false},{}

function hook.add(event, func, id, state, debugonly)
	assert(type(event) == "string", "bad argument #1 to hook.add (string expected, got "..type(event)..")")
	assert(type(func) == "function", "bad argument #2 to hook.add (function expected, got "..type(func)..")")
	assert(type(id) == "string", "bad argument #3 to hook.add (string expected, got "..type(func)..")")
	local func = func
	if state ~= nil then
		assert(type(state) == "string", "bad argument #4 to hook.add (string expected, got "..type(func)..")")
		local oldfunc,s = func,state
		func = function(...)
			if _G.game.state == s then
				return oldfunc(...)
			end
			return true
		end
	end
	if debugonly ~= nil then
		assert(type(debugonly) == "boolean", "bad argument #5 to hook.add (boolean expected, got "..type(func)..")")
		local oldfunc,dbg = func,debugonly
		func = function(...)
			if _G.game.debug == dbg then
				return oldfunc(...)
			end
			return true
		end
	end
	game.hooks[id] = {event, func}
end

function hook.call(event, ...)
	local queue,out = {},{}
	for k,v in pairs(game.hooks) do
		if v[1] == event then
			local ret,err = v[2](...)
			if ret == false then
				error("Hook "..k.." failed! Error: "..err)
			else
				if ret then
					table.insert(out, ret)
				end
			end
		end
	end
	return out
end

function love.run()
  if love.graphics then
    love.graphics.clear()
  end
  hook.call("initial")
  if love.graphics then
    love.graphics.present()
  end

  hook.call("load")
  local dt = 0

  if love.audio then
    hook.add("quit", function()
      love.audio.stop()
    end, "audioquitcheck")
  end

  while true do
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end
    hook.call("update", dt)
    if love.event then
      for e,a,b,c in love.event.poll() do
        if e == "q" then
          game.quit = true
        end
      love.handlers[e](a,b,c)
      end
    end

    if game.quit == true then
      hook.call("quit")
      return
    end

    if love.graphics then
      love.graphics.clear()
      hook.call("draw")
      love.graphics.present()
    end

    if love.timer then
      love.timer.sleep(1)
    end
  end
end