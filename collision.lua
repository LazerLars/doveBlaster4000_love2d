-- collision.lua

local collision = {}

local weapon = require "weapon"
local enemy = require "enemy"

function collision.check()
    bullets = weapon.bulletList
    clayDoves = enemy.list



    for bulletIndex, bullet in ipairs(bullets) do
        print('bullet ' .. bulletIndex .. ' xy = ' .. bullet.x .. ',' .. bullet.y)
        for doveIndex, dove in ipairs(clayDoves) do
            print('dove ' .. doveIndex .. ' xy = ' .. dove.x .. ',' .. dove.y)
            --correct this so i check for a collision here.. both bullet aand dove have x,y and w and h proptery
             -- Check for collision based on x, y, width, and height
            if bullet.x < dove.x + dove.w and
            bullet.x + bullet.w > dove.x and
            bullet.y < dove.y + dove.h and
            bullet.y + bullet.h > dove.y then
                print('collision!!!')
                print('collision!!!')
            end
        end
    end
    
    --print('length clays: ' .. #clayDoves)
    -- Collision detection logic
    -- For example, check if the player's bounding box intersects with the enemy's bounding box
    return checkBoundingBoxCollision(bullet, enemy)
end

function checkBoundingBoxCollision(obj1, obj2)
    -- Bounding box collision logic
end

function collision.update()
    collision.check()
end

return collision
