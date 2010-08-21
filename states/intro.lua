local ts = -1

--[[ Time-cues:
 - Peace:
 0.2: bird chirp
 1.8: next state
 - Bomb:
 0.4: fling sound
 0.9: bomb starts falling
 2.3: impact, next state
 - Flash, AAaahh:
 0.1: boom sound
 0.8: start fadeout
 1.2: next state
 - Happiness:
 0.2: yaaaayy sounds
 1.4: fadeout
--]]

local sources = {}
local played = {}

hook.add("update", function(dt)
  if ts == -1 then ts = 0 end
  ts = ts + dt
  if not sources.chirp then
    sources.chirp = love.audio.newSource("sfx/chirp.ogg", "static")
  end
  if ts >= 0.2 and not played.chirp then
    love.audio.play(sources.chirp)
    played.chirp = true
  end
  if ts >= 0.4 and not sources.bombfall then
    sources.bombfall = love.audio.newSource("sfx/bombfall.ogg", "static")
  end
  if ts >= 1.8 then
    game.state = "i-bomb"
    ts = 0
  end
end, "intro-upd-peace", "i-peace")

hook.add("update", function(dt)
  ts = ts + dt
  if ts >= 0.4 and not played.bombfall then
    love.audio.play(sources.bombfall)
    played.bombfall = true
  end
end, "intro-upd-bomb", "i-bomb")