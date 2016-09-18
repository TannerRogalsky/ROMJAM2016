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

local MUSIC_VOLUME = 1
local MAX_WELL_DEPTH = 9999

local MUSIC_FADE_IN_INTERVAL = 0.1
local MUSIC_FADE_OUT_INTERVAL = 0.01

local MUSIC_FADE_CUTOFF = 0.01

local function getPathForMusicTrack(fileName)
  return MUSIC_TRACKS_DIR .. fileName
end

function MusicTrack:initialize(fileName, heightStartThreshold, heightEndThreshold)
  local musicTrackPath = getPathForMusicTrack(fileName)

  self.source = love.audio.newSource(musicTrackPath, 'stream')
  self.source:setLooping(true)
  self.source:setVolume(0)
  self.source:play()

  self.heightStartThreshold = heightStartThreshold
  self.heightEndThreshold = heightEndThreshold

  self.isFadingOut = false
  self.isFadingIn = false
end

function MusicTrack:play()
  if game.disableAudio then return end

  self.isFadingIn = true
end

function MusicTrack:stop()
  self.isFadingOut = true
end

function MusicTrack:update()
  if (self.isFadingOut) then
    local currentVolume = self.source:getVolume()
    local nextVolume = currentVolume - MUSIC_FADE_OUT_INTERVAL

    self.source:setVolume(nextVolume)

    if (nextVolume <= MUSIC_FADE_CUTOFF) then 
      self.isFadingOut = false 
      self.source:setVolume(0)
    end
  end

  if (self.isFadingIn) then
    local currentVolume = self.source:getVolume()
    local nextVolume = currentVolume + MUSIC_FADE_IN_INTERVAL

    self.source:setVolume(nextVolume)

    if (nextVolume >= MUSIC_VOLUME) then 
      self.isFadingIn = false 
      self.source:setVolume(MUSIC_VOLUME)
    end
  end
end

-- MUSIC TRACKS
local MusicTracks = class('MusicTracks', Base)

function MusicTracks:initialize()
  self.TRACK_NAMES = MUSIC_TRACK_NAMES

  self.baseTrackName = MUSIC_TRACK_NAMES.SILENT

  self[MUSIC_TRACK_NAMES.SILENT] = MusicTrack:new('silentStem.ogg', 0, MAX_WELL_DEPTH)
  self[MUSIC_TRACK_NAMES.LEAD1]  = MusicTrack:new('lead1Stem.ogg', 0, MAX_WELL_DEPTH)
  self[MUSIC_TRACK_NAMES.LEAD2]  = MusicTrack:new('lead2Stem.ogg', 20, 550) 
  self[MUSIC_TRACK_NAMES.LEAD3]  = MusicTrack:new('lead3Stem.ogg', 50, 530)
  self[MUSIC_TRACK_NAMES.TWANG]  = MusicTrack:new('twangStem.ogg', 80, 500)
  self[MUSIC_TRACK_NAMES.BASS]   = MusicTrack:new('bassStem.ogg', 110, 400)
  self[MUSIC_TRACK_NAMES.KICK]   = MusicTrack:new('kickStem.ogg', 150, 480)
  self[MUSIC_TRACK_NAMES.TOM]    = MusicTrack:new('tomStem.ogg', 180, 440)
  self[MUSIC_TRACK_NAMES.WACKY]  = MusicTrack:new('wackyLeadStem.ogg', 210, 380)
end

return MusicTracks
