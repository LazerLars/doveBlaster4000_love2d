-- collision.lua

local collision = {}

local weapon = require "weapon"
local enemy = require "enemy"
local event = require "event"
local particles = require "UtillityFunctions.inLoveParticles"

function collision.checkForCollisionBulletAndEnemy()

    --loop through all bullets and see if it hits a enemy
    for bulletIndex, bullet in ipairs(weapon.bulletList) do
        for doveIndex, dove in ipairs(enemy.list) do
             -- Check for collision based on x, y, width, and height
             if bullet.x < dove.x + dove.w and -- Right edge of bullet is to the left of the right edge of dove
             bullet.x + bullet.w > dove.x and -- Left edge of bullet is to the right of the left edge of dove
             bullet.y < dove.y + dove.h and -- Bottom edge of bullet is above the top edge of dove
             bullet.y + bullet.h > dove.y then -- Top edge of bullet is below the bottom edge of dove
              print('bulletIndex: ' .. bulletIndex .. 'collides with doveIndex: ' .. doveIndex)
              particles.createSimple(dove.x, dove.y, 'left')
              particles.createSimple(dove.x, dove.y, 'right')
             
              enemy.remove(doveIndex)
              enemy.playSfx_enemyDead()
              weapon.removeBullet(bulletIndex)

              --increase score
              event.publish('increaseScore', 100)
            end
        end
    end
end

function collision.checkForCollision(obj1List, obj2List)
    --obj1List = weapon.bulletList
    --obj2List = enemy.list

    for obj1Index, obj1 in ipairs(obj1List) do
        --print('bullet ' .. bulletIndex .. ' xy = ' .. bullet.x .. ',' .. bullet.y)
        for obj2Index, obj2 in ipairs(obj2List) do
            
             -- Check for collision based on x, y, width, and height
             if obj1.x < obj2.x + obj2.w and -- Right edge of bullet is to the left of the right edge of dove
             obj1.x + obj1.w > obj2.x and -- Left edge of bullet is to the right of the left edge of dove
             obj1.y < obj2.y + obj2.h and -- Bottom edge of bullet is above the top edge of dove
             obj1.y + obj1.h > obj2.y then -- Top edge of bullet is below the bottom edge of dove
              print('objIndex: ' .. obj1Index .. 'collides with obj2Index: ' .. obj2Index)
              --collision logic goes here
              --enemy.remove(obj2Index)
              --weapon.removeBullet(obj1Index)
            end
        end
    end
end



function collision.update()
    collision.checkForCollisionBulletAndEnemy()
end

return collision
