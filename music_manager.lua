local MusicTracks = require('music_tracks')

-- PRIVATE
local WELL_HEIGHT = 0

local function getSetPieceDistanceFromFloor(setPiece)
  return WELL_HEIGHT - setPiece.y
end

local function getHighestSetPiece(setPieces)
  local highestSetPiece = 0

  for k, setPiece in pairs(setPieces) do
    local setPieceDistanceFromFloor = getSetPieceDistanceFromFloor(setPiece)

    if setPieceDistanceFromFloor > highestSetPiece then
      highestSetPiece = setPieceDistanceFromFloor
    end
  end

  return highestSetPiece
end

local function shouldPlayMusicTrack(musicTrack, highestSetPiece)
  return musicTrack.heightStartThreshold <= highestSetPiece and
    highestSetPiece <= musicTrack.heightEndThreshold
end

local function playMusicTracks(musicTracks, highestSetPiece)
  for musicTrackNameKey, musicTrackName in pairs(musicTracks.TRACK_NAMES) do
    local musicTrack = musicTracks[musicTrackName]
    musicTrack:update()

    if shouldPlayMusicTrack(musicTrack, highestSetPiece) then
      musicTrack:play()
    else
      musicTrack:stop()
    end
  end
end

function shouldRestartMusicTracks(musicTracks)
  local baseTrack = musicTracks[musicTracks.baseTrackName]

  return baseTrack.source:isStopped()
end

-- PUBLIC
local MusicManager = class('MusicManager', Base)

function MusicManager:initialize()
  Base.initialize(self)
  WELL_HEIGHT = g.getHeight()

  self.tracks = MusicTracks:new()
end

function MusicManager:update(setPieces)
  local highestSetPiece = getHighestSetPiece(setPieces)

  playMusicTracks(self.tracks, highestSetPiece)
end

return MusicManager
