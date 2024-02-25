--inLoveSoundPlayer.lua

local inLoveSoundPlayer = {}


function inLoveSoundPlayer.playSfx(filePath)
    local sound = love.audio.newSource(filePath, 'stream')
    love.audio.play(sound)
    sound:play()
end