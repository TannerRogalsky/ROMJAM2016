local SFX_DIR = '/sounds/fx/'
local SFX_NAMES = {
  PIECE_IMPACT = 'pieceImpact'
}

local function getPathForSFX(fileName)
  return SFX_DIR .. fileName
end

-- SOUND CLASS
--------------
local Sound = class('Sound', Base)

function Sound:initialize(fileName, defaultVolume)
  local sfxPath = getPathForSFX(fileName)

  self.source = love.audio.newSource(sfxPath)
  self.source:setVolume(defaultVolume)
end

function Sound:play()
  self.source:play()
end

-- SOUNDS COLLECTION
--------------------
local Sounds = class('Sounds', Base)

function Sounds:initialize()
  self[SFX_NAMES.PIECE_IMPACT] = Sound:new('pieceImpact.wav', 0.4)
end

-- SOUND MANAGER
----------------
local SoundManager = class('SoundManager', Base)

function SoundManager:initialize()
  self.SFX = SFX_NAMES

  self.sounds = Sounds:new()
end

function SoundManager:playSound(sfxName)
  local sound = self.sounds[sfxName]

  if sound then
    sound:play()
  end
end

return SoundManager
