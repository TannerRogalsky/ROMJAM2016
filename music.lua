local Music = class('Music', Base)

local bass_track
local lead_track

function Music.static.initialize()
  bass_track = love.audio.newSource('sounds/music/bass_stem.wav')
  lead_track = love.audio.newSource('sounds/music/lead_stem.wav')
  bass_track:play()
end
 
function Music.static.update()
  if bass_track:isStopped() then
    bass_track:play()
    lead_track:play()
  end
end

return Music
