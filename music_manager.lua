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
  return musicTrack.heightThreshold <= highestSetPiece
end

local function getMusicTracksToPlay(musicTracks, highestSetPiece)
  local musicTracksToPlay = {}

  for musicTrackNameKey, musicTrackName in pairs(musicTracks.TRACK_NAMES) do
    local musicTrack = musicTracks[musicTrackName]

    if shouldPlayMusicTrack(musicTrack, highestSetPiece) then
      table.insert(musicTracksToPlay, musicTrackName)
    end
  end

  return musicTracksToPlay
end

local function playMusicTracks(musicTracks, musicTracksToPlay)
  for index, musicTrackName in ipairs(musicTracksToPlay) do
    musicTracks[musicTrackName].source:play()
  end
end

function shouldRestartMusicTracks(musicTracks)
  local baseTrack = musicTracks[musicTracks.baseTrackName]

  return baseTrack.source:isStopped()
end

-- PUBLIC 
local MusicManager = class('MusicManager', Base)

function MusicManager:initialize()
  WELL_HEIGHT = g.getHeight()

  self.tracks = MusicTracks:new()
end
 
function MusicManager:update(setPieces)
  local highestSetPiece = getHighestSetPiece(setPieces)

  if shouldRestartMusicTracks(self.tracks) then
    local musicTracksToPlay = getMusicTracksToPlay(self.tracks, highestSetPiece)
    playMusicTracks(self.tracks, musicTracksToPlay)
  end
end

return MusicManager
