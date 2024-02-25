--soundPlayer.lua

local soundPlayer = {}


function soundPlayer.playSfx(filePath)
    local sound = love.audio.newSource(filePath, 'stream')
    love.audio.play(sound)
    sound:play()
end