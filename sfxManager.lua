local sfxManager = {}

function sfxManager.load()
    sfxManager.list = {
        shellLoad_00 = 'sfx/shellLoad_00.mp3',
        shellLoad_01 = 'sfx/shellLoad_01.mp3',
        pop_00 = 'sfx/sfx_pop.mp3',
        fire_00 = 'sfx/sfx_fire.mp3'
    }
end

function sfxManager.update()

end

function sfxManager.draw()

end

--sfxManager.playSound('sfx/shellLoad_00.mp3')
function sfxManager.playSound(sfxPath)
    local sfx_shoot = love.audio.newSource(sfxPath, 'stream')
    love.audio.play(sfx_shoot)
    sfx_shoot:play()
end

return sfxManager