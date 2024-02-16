local inputManager = {}

local weapon = require "weapon"

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
        --bullet.x = shotgun.bulletSpawnX
        --bullet.y = shotgun.bulletSpawnY
        --enemy.create(math.random(10, 120), math.random(10, 90))
    end
end

return inputManager


