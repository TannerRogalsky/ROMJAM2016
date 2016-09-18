-- MUSIC TRACK
local MusicTrack = class('MusicTrack', Base)

local MUSIC_TRACKS_DIR = '/sounds/music/'
local MUSIC_TRACK_NAMES = {
  SILENT = 'silent',
  LEAD1 = 'lead1',
  LEAD2 = 'lead2',
  LEAD3 = 'lead3',
  TWANG = 'twang',
  WACKY = 'wacky',
  BASS = 'bass',
  KICK = 'kick',
  TOM = 'tom'
}

local function getPathForMusicTrack(fileName)
  return MUSIC_TRACKS_DIR .. fileName
end

function MusicTrack:initialize(fileName, heightThreshold)
  local musicTrackPath = getPathForMusicTrack(fileName)

  self.source = love.audio.newSource(musicTrackPath)
  self.source:setLooping(true)
  self.source:setVolume(0)
  self.source:play()

  self.heightThreshold = heightThreshold
end

function MusicTrack:play()
  if game.disableAudio then return end
  self.source:setVolume(1)
end

-- MUSIC TRACKS
local MusicTracks = class('MusicTracks', Base)

function MusicTracks:initialize()
  self.TRACK_NAMES = MUSIC_TRACK_NAMES

  self.baseTrackName = MUSIC_TRACK_NAMES.SILENT

  self[MUSIC_TRACK_NAMES.SILENT] = MusicTrack:new('silentStem.wav', 0)
  self[MUSIC_TRACK_NAMES.LEAD1]  = MusicTrack:new('lead1Stem.wav', 0)
  self[MUSIC_TRACK_NAMES.LEAD2]  = MusicTrack:new('lead2Stem.wav', 60)
  self[MUSIC_TRACK_NAMES.LEAD3]  = MusicTrack:new('lead3Stem.wav', 100)
  self[MUSIC_TRACK_NAMES.TWANG]  = MusicTrack:new('twangStem.wav', 150)
  self[MUSIC_TRACK_NAMES.BASS]   = MusicTrack:new('bassStem.wav', 200)
  self[MUSIC_TRACK_NAMES.KICK]   = MusicTrack:new('kickStem.wav', 250)
  self[MUSIC_TRACK_NAMES.TOM]    = MusicTrack:new('tomStem.wav', 300)
  self[MUSIC_TRACK_NAMES.WACKY]  = MusicTrack:new('wackyLeadStem.wav', 400)
end

return MusicTracks
