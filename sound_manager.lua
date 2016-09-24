local SFX_DIR = '/sounds/fx/'
local SFX_NAMES = {
  PIECE_IMPACT = 'pieceImpact',
  FOSSIL_IMPACT = 'fossilImpact',
  SQUEAL = 'squeal'
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

-- SOUND GROUP
--------------
local SoundGroup = class('SoundGroup', Base)

function SoundGroup:initialize(sounds)
  self.sounds = sounds
end

function SoundGroup:play()
  local randomSoundInGroup = self.sounds[math.random(#self.sounds)]

  randomSoundInGroup.source:play()
end

-- SOUNDS COLLECTION
--------------------
local Sounds = class('Sounds', Base)

function Sounds:initialize()
  self[SFX_NAMES.PIECE_IMPACT] = Sound:new('pieceImpact.ogg', 0.4)
  self[SFX_NAMES.FOSSIL_IMPACT] = Sound:new('fossilImpact.ogg', 0.5)

  local squeals = {}

  table.insert(squeals, Sound:new('squeal1.ogg', 0.4))
  table.insert(squeals, Sound:new('squeal2.ogg', 0.4))
  table.insert(squeals, Sound:new('squeal3.ogg', 0.4))

  self[SFX_NAMES.SQUEAL] = SoundGroup:new(squeals)
end

-- SOUND MANAGER
----------------
local SoundManager = class('SoundManager', Base)

function SoundManager:initialize()
  Base.initialize(self)
  self.SFX = SFX_NAMES

  self.sounds = Sounds:new()
end

function SoundManager:playSound(sfxName)
  if game.disableAudio then return end

  local sound = self.sounds[sfxName]

  if sound then
    sound:play()
  end
end

return SoundManager
