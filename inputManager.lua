local inputManager = {}

local weapon = require "weapon"
local enemy = require "enemy"
local particles = require "UtillityFunctions.inLoveParticles"
local event = require "event"
local sfxManager = require 'sfxManager'

function inputManager.load()
    sfxManager.load()
end

function inputManager.update(dt)

end

function inputManager.draw()

end

--keypressed cant detect ½, so thats why we use textinput
-- function love.textinput(text)
--     if text == '½' then
--         print('ma dude ma dude')
--         -- event.publish('gameState')
--         event.publish('gameState')
--     end
--     if text == 'z' then
--         print('ma dude ma dude')
--         -- event.publish('gameState')
--         event.publish('gameState', 1)
--     end
-- end

function  love.keypressed(key)
    if publicGameState == 0 then
        
        if key == 'right' then
            sfxManager.playSound(sfxManager.list.shellLoad_00)
            gameModeCounter = gameModeCounter + 1
            -- set number to 2 if we want to include options
            --if gameModeCounter > 2 th½en
            if gameModeCounter > 1 then
                gameModeCounter = 0
            end
            --gameModeText = '*Championship*'
        end
        if key == 'left' then
            sfxManager.playSound(sfxManager.list.shellLoad_01)
            --gameModeText = '*Free Play*'
            gameModeCounter = gameModeCounter - 1
            if gameModeCounter < 0 then
                -- set gameCounter = 2 if we want to include options
                gameModeCounter = 1
            end
        end
    end
        if key == 'return' then
        inputManager.choosePlayMode()
    end
    if key == 'escape' then
        if gameOver == false then
            event.publish('gameState', 0)
        end
    end
    if key == 'space' then
       inputManager.spaceAndLeftMouseFunc()
    end
    if key == '1' then
        gameOver = false
        event.publish('resetLife', 5)

    end
    -- throw doves in freeplay
    if key == 'q' then
        --enemy.create(math.random(10, 120), math.random(10, 90))
        --spawn enemy on right side
        -- we only want to allow selfe throw in free play
        inputManager.qAndRightMouseClick()
        
        --bullet.x = shotgun.bulletSpawnX
        --bullet.y = shotgun.bulletSpawnY
        --enemy.create(math.random(10, 120), math.random(10, 90))
    end

    if key == 'w' then
        weapon.spawnPlayerRandomly()
    end
    if key == 'a' then
        particles.createSimple(50, 50, 'right')
        particles.createSimple(50, 50, 'left')
        event.publish('screenShake')
    end
end

function inputManager.choosePlayMode()
    print('lets the blasting begin...')
        if gameModeCounter == 0 then
            event.publish('gameState', 4)
            event.publish('resetScore')

        elseif gameModeCounter == 1 then
            event.publish('gameState', 5)
            event.publish('resetScore')
            
        elseif gameModeCounter == 2 then
            event.publish('gameState', 6)
            event.publish('resetScore')
        end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        inputManager.spaceAndLeftMouseFunc()
        print(mouseX .. ',' .. mouseY)
        -- Left mouse button clicked
        -- Your code here
    elseif button == 2 then
        inputManager.qAndRightMouseClick()
    end
end

function inputManager.spaceAndLeftMouseFunc()
    local wait = false
    if publicGameState == 0 then
        inputManager.choosePlayMode()
        wait = true
    end
    -- gamestate 4 = freeplay
    if gameOver == false and wait == false or publicGameState == 4 and wait == false then
        weapon.addBullet()
    end
end

function inputManager.qAndRightMouseClick()
    -- we only want to allow one dove at a time
    if #enemy.list == 0 then
        if publicGameState == 4 then
                
            if weapon.specs.spawnRightSide == true then
                --enemy.create(8, math.random(80,124), false)
                --spawn enemy on left side
                enemy.createEnemyOnLeft()
            else
                -- enemy.create(120, math.random(80,124), true)
                enemy.createEnemyOnRight()
            end
        end
        
    end
end

return inputManager


