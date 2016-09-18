-- MUSIC TRACK
local MusicTrack = class('MusicTrack', Base)

local MUSIC_TRACKS_DIR = '/sounds/music/'
local MUSIC_TRACK_NAMES = {
  BASS = 'bass', 
  LEAD = 'lead'
}

local function getPathForMusicTrack(fileName)
  return MUSIC_TRACKS_DIR .. fileName
end

function MusicTrack:initialize(fileName, heightThreshold)
  local musicTrackPath = getPathForMusicTrack(fileName)

  self.source = love.audio.newSource(musicTrackPath)
  self.heightThreshold = heightThreshold
end

-- MUSIC TRACKS
local MusicTracks = class('MusicTracks', Base)

function MusicTracks:initialize()
  self.TRACK_NAMES = MUSIC_TRACK_NAMES

  self.baseTrackName = MUSIC_TRACK_NAMES.BASS

  self[MUSIC_TRACK_NAMES.BASS] = MusicTrack:new('bassStem.wav', 0)
  self[MUSIC_TRACK_NAMES.LEAD] = MusicTrack:new('leadStem.wav', 60)
end

return MusicTracks
