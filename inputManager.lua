local inputManager = {}

local weapon = require "weapon"
local enemy = require "enemy"
local particles = require "UtillityFunctions.inLoveParticles"

function inputManager.load()

end

function inputManager.update(dt)

end

function inputManager.draw()

end

function  love.keypressed(key)
    if key == 'space' then
        print('fire in the hole...')
        weapon.addBullet()
    end
    if key == 'q' then
        print('adding enemy...')
        enemy.create(math.random(10, 120), math.random(10, 90))
        --bullet.x = shotgun.bulletSpawnX
        --bullet.y = shotgun.bulletSpawnY
        --enemy.create(math.random(10, 120), math.random(10, 90))
    end

    if key == 'w' then
        local x = math.random(23,110)
        print(x)
        weapon.setGunStartPosX(x)
        print('pos: ' .. weapon.specs.spawnPosX)
        --weapon.startPos(math.random(25,105))
    end
    if key == 'a' then
        particles.createSimple(50, 50, 'right')
        particles.createSimple(50, 50, 'left')
    end
end

return inputManager


