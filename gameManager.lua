-- gameManager.lua

local player = require "player"
local enemy = require "enemy"
local weapon = require "weapon"
local event = require "event"
local inLoveColors = require "UtillityFunctions.inLoveColors"
local inputManager = require "inputManager"
local collision = require "collision"
local inLoveParticles = require "UtillityFunctions.inLoveParticles"
local inLoveJuicer = require "UtillityFunctions.inLoveJuicer"

local gameManager = {}

gameOver = false
gameModeCounter = 0
gameModeText = '*Free Play*'
publicGameState = 0

function gameManager.load()
    print('gameManager started...')
    gameManager.list = {
        score = 0,
        lifePoints = 5,
        switchSide = false,
        dovesPerSide = 5
        
    }
    -- we want to keep track of when we need to switch side in freeplay mode
    gameManager.list.nextSideSwitch = gameManager.list.dovesPerSide
    player.load()
    enemy.load()
    weapon.load()
    inputManager.load()
    inLoveParticles.load()
    inLoveJuicer.load()

    gameManager.gameModeSettings = {
        delaySideSwitch = 1,
        sideSwitchTimer = 0,
        doveLaunchTimer = 0,
        doveLaunchInterval = 2,
        doveLaunchDelayOnSideSwitch = 3,
        doveLaunchDelayOnSideSwitchTimer = 0,
        doveLaunchDelayBool = false
    }



    gameManager.gameState = {
        current = 0,
        start = 0,
        playing = 1,
        menu = 2,
        gameover = 3,
        freePlay = 4, -- gameModeText = '*Free Play*'-- practice play, eternal doves
        championship = 5, -- 3 shots from each side untill you miss 3 shots
        options = 6 -- choose how many shots from each side, how many misses allowed
    }

    --blue
    -- love.graphics.setBackgroundColor(77/255, 142/255, 217/255)
    --grey
    love.graphics.setBackgroundColor(84/255, 78/255, 94/255)
    --brown
    -- love.graphics.setBackgroundColor(145/255, 63/255, 51/255)
    --white
    -- love.graphics.setBackgroundColor(1,1,1)
    --green
    -- love.graphics.setBackgroundColor(0, 212/255, 59/255)

    --subscribe to a event. the function is called every time a playerCollision is published
    --even though this is placed in the load function, if you move this to the update function is can be called 900-1000 times for each published event.
    --so keep events subscribtion in the load function 
    event.subscribe("increaseScore", function(score)
        gameManager.incrementScore(score)
        --gameManager.incrementScore()
    end)
    -- Additional game manager initialization if needed

    event.subscribe('bulletOutOfScreen', function()
        if gameManager.list.lifePoints > 0 and gameManager.gameState.current ~= gameManager.gameState.freePlay then
            gameManager.list.lifePoints = gameManager.list.lifePoints - 1
        end
        if gameManager.list.lifePoints <= 0 then
            gameOver = true
        end
    end)

    event.subscribe("resetLife", function(lifePoints)
        gameManager.list.lifePoints = lifePoints
        gameManager.list.score = 0
        --gameManager.incrementScore()
    end)
    
    event.subscribe("resetScore", function()
        gameManager.list.score = 0
        --gameManager.incrementScore()
    end)

    event.subscribe("screenShake", function()
        inLoveJuicer.triggerScreenShake('enemyDead', 0.5)
        --gameManager.incrementScore()
    end)

    event.subscribe("gameState", function(newState)
        if newState == nil then
            
            gameManager.gameState.current = gameManager.gameState.current + 1
        end
        if gameManager.gameState.current > 3 then
            gameManager.gameState.current = 0
        end
        if newState ~= nil then
            gameManager.gameState.current = newState
            publicGameState = newState
        end
    end)

    
end

function gameManager.update(dt)

    if gameManager.gameState.current == gameManager.gameState.freePlay or gameManager.gameState.current == gameManager.gameState.championship then
        
        player.update(dt)
        enemy.update(dt)
        weapon.update(dt)
        inputManager.update(dt)
        collision.update()
        inLoveParticles.update(dt)
        inLoveJuicer.update(dt)
        --gameManager.playMode_1(dt, 2, 2, 1, false)
        if gameManager.gameState.current == gameManager.gameState.championship then
            gameManager.playModeCycle(dt, 5, 2, 1, true)
        end
        if gameManager.gameState.current == gameManager.gameState.freePlay then
            gameOver = false
            
            --bug handleing switch side for on every 3
            -- we need to handle every 3rd dove is not spamming side switch
            if #enemy.list == 0 and enemy.doveCount % gameManager.list.dovesPerSide == 0 and enemy.doveCount > 0 then
                -- check if we cant switch side
                if gameManager.list.nextSideSwitch == enemy.doveCount then
                    if weapon.specs.spawnRightSide then
                        weapon.spawnPlayerRight(false)
                    else
                        weapon.spawnPlayerRight(true)
                    end
                    -- set the number count for the next side switch so it not stuck in a loop of switching sides when the % is == 0
                    gameManager.list.nextSideSwitch = gameManager.list.nextSideSwitch + gameManager.list.dovesPerSide
                end
            end
        end
    end

    if gameManager.gameState.current == gameManager.gameState.start then
        gameManager.manageGameModeText()
    end
    
      -- Game manager update logic
    
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    inLoveJuicer.drawStart()

    -- local bg = love.graphics.newImage('sprites/background/background_00.png')
    -- love.graphics.draw(bg, 1,1)

    --draw game mode select screen
    if gameManager.gameState.current == gameManager.gameState.start and gameOver == false and gameManager.list.lifePoints > 0 then
        inLoveColors.ColorPalette_pico8Micro('yellow')
        titleText = 'doveBLASTER'
        love.graphics.print("¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸", 1, 1)
        love.graphics.print(titleText, 10, 20)
        love.graphics.print('4000', 1+(#titleText*8), 28)
        love.graphics.print('¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸', 1, 38)
        inLoveColors.ColorPalette_pico8Micro('blue')
        local boxW = 17*8
        local boxH = 12
        love.graphics.rectangle('fill', (screenWidth/2)-(boxW/2)+2, (screenHeight/2)-(boxH/2)-3, boxW, boxH)
        inLoveColors.ColorPalette_pico8Micro('white')
        love.graphics.print('SELECT GAMEMODE', (screenWidth/2)-(boxW/2)+8, (screenHeight/2)-(boxH/2))
        inLoveColors.ColorPalette_pico8Micro('white')
        love.graphics.print(gameModeText, (screenWidth/2)-((8*#gameModeText)/2), (screenHeight/2)-(boxH/2)+12)
        inLoveColors.ColorPalette_pico8Micro('white')
        if gameModeText == '*Free Play*' then
            inLoveColors.ColorPalette_pico8Micro('green')
            local shootString = 'shoot ='
            local y = 85
            love.graphics.print(shootString, (screenWidth/2)-((8*#shootString)/2), y)
            y = y + 10
            inLoveColors.ColorPalette_pico8Micro('pink')
            love.graphics.print('space,left mouse', 1, y)
            y = y + 10
            inLoveColors.ColorPalette_pico8Micro('green')
            local throwDovesString = 'throw doves ='
            love.graphics.print(throwDovesString, (screenWidth/2)-((8*#throwDovesString)/2), y)
            y = y + 10
            inLoveColors.ColorPalette_pico8Micro('pink')
            love.graphics.print('Q,right mouse', 1, y)
            inLoveColors.ColorPalette_pico8Micro('white')
        elseif gameModeText == '*Championship*' then
            local y = 85
            inLoveColors.ColorPalette_pico8Micro('green')
            local shootString = 'shoot ='
            love.graphics.print(shootString, (screenWidth/2)-((8*#shootString)/2), y)
            y = y + 10
            inLoveColors.ColorPalette_pico8Micro('pink')
            love.graphics.print('space,left mouse', 1, y)
            inLoveColors.ColorPalette_pico8Micro('white')
        end
    end
    
    -- if we are either in champion ship or freeplay mode
    if gameManager.gameState.current == gameManager.gameState.championship or gameManager.gameState.current == gameManager.gameState.freePlay  then
        player.draw()
        enemy.draw()
        weapon.draw()
        inputManager.draw()
        inLoveParticles.draw()
        

        -- print score to the screen
        inLoveColors.ColorPalette_pico8Micro('yellow')
        --center pos when score = 0 
        if gameManager.list.score == 0 then
            love.graphics.print(gameManager.list.score, (screenWidth/2),10)
        --center pos when 100 -> 999
        elseif gameManager.list.score >= 100 and gameManager.list.score <= 999 then   
            love.graphics.print(gameManager.list.score, (screenWidth/2)-12,10)
        --center pos when 1000 -> 99,0000
        else
            love.graphics.print(gameManager.list.score, (screenWidth/2)-16,10)
            
            inLoveColors.ColorPalette_pico8Micro('white')
        end
        -- Additional game manager drawing logic if needed

        -- prints score to the screen, disable if we are in freeplay mode
        if gameManager.gameState.current ~= gameManager.gameState.freePlay then
            inLoveColors.ColorPalette_pico8Micro('pink')
            love.graphics.print(gameManager.list.lifePoints, (1),1)
            inLoveColors.ColorPalette_pico8Micro('white')
        end
        inLoveColors.ColorPalette_pico8Micro('white')
    end

    -- prints gameOver to the screen
    if gameManager.list.lifePoints == 0 then
        inLoveColors.ColorPalette_pico8Micro('blue')
        local boxW = 76
        local boxH = 12
        love.graphics.rectangle('fill', (screenWidth/2)-(boxW/2), (screenHeight/2)-(boxH/2)-3, boxW, boxH)
        inLoveColors.ColorPalette_pico8Micro('white')
        love.graphics.print('GAME OVER', (screenWidth/2)-(boxW/2)+2, (screenHeight/2)-(boxH/2))
        inLoveColors.ColorPalette_pico8Micro('black')
        love.graphics.print('Press 1 to', (screenWidth/2)-((8*10)/2), (screenHeight/2)-(boxH/2)+12)
        love.graphics.print('restart', (screenWidth/2)-((8*7)/2), (screenHeight/2)-(boxH/2)+20)
        inLoveColors.ColorPalette_pico8Micro('white')
    end
    inLoveJuicer.drawEnd()
end

function gameManager.spawnEnemy(x, y)
    enemy.create(x, y)
end

function gameManager.incrementScore(scoreIncrement)
    --if no scoreIncrement is added, then we just want to add 1
    if scoreIncrement == nill then
        gameManager.list.score = gameManager.list.score + 1
    else
        gameManager.list.score = gameManager.list.score + scoreIncrement
    end
    
    --print("Score: " .. gameManager.list.score)
end

-- launch doves based on settigns set in 
function gameManager.launchEnemiesHandler(dt)
    gameManager.gameModeSettings.doveLaunchTimer = gameManager.gameModeSettings.doveLaunchTimer + dt

    -- Check if the elapsed time has reached the interval
    if gameManager.gameModeSettings.doveLaunchTimer >= gameManager.gameModeSettings.doveLaunchInterval then
        if weapon.specs.spawnRightSide == true then
            --enemy.create(8, math.random(80,124), false)
            --spawn enemy on left side
            enemy.createEnemyOnLeft()
        else
            -- enemy.create(120, math.random(80,124), true)
            enemy.createEnemyOnRight()
        end
        -- Reset the elapsed time for the next interval
        gameManager.gameModeSettings.doveLaunchTimer = 0
    end
end

-- configure current gamemode and manage it
function gameManager.playModeCycle(dt, dovePerSide, doveLaunchInterval, delayForSideSwitch, start)
    gameManager.gameModeSettings.doveLaunchInterval = doveLaunchInterval
    gameManager.gameModeSettings.delaySideSwitch = delayForSideSwitch
    --delay side switch
    local allowSideSwitch = false
    --if spawn counter is greater than 0 and enemy.list is 0 then we know we can init the delay timer
    if #enemy.list == 0 and enemy.spawnCounter ~= 0 then
        gameManager.gameModeSettings.sideSwitchTimer = gameManager.gameModeSettings.sideSwitchTimer + dt
        if gameManager.gameModeSettings.sideSwitchTimer >= gameManager.gameModeSettings.delaySideSwitch then
            allowSideSwitch = true
            gameManager.gameModeSettings.sideSwitchTimer = 0
        end
    end
    
    -- wait delay on next dove launch on side switch 
    if gameManager.gameModeSettings.doveLaunchDelayBool then
        gameManager.gameModeSettings.doveLaunchDelayOnSideSwitchTimer = gameManager.gameModeSettings.doveLaunchDelayOnSideSwitchTimer + dt
        if gameManager.gameModeSettings.doveLaunchDelayOnSideSwitchTimer >= gameManager.gameModeSettings.doveLaunchDelayOnSideSwitch then
            gameManager.gameModeSettings.doveLaunchDelayBool = false
            print('wait over. dove launch starts')
        end
    end
    if start and gameManager.gameModeSettings.doveLaunchDelayBool == false then
        gameManager.launchEnemiesHandler(dt)
    end
    --switch spawn side for every 'dovePerSide' trap shoot
    --#enemy.list == 0 then we know we either shot the last dove or it out of the screen and then removed before we switch side
    if enemy.spawnCounter % dovePerSide == 0 and enemy.spawnCounter ~= 0 and #enemy.list == 0 and allowSideSwitch == true  then
        enemy.spawnCounter = 0        
        if weapon.specs.spawnRightSide  then
            weapon.spawnPlayerRight(false)
        else
            weapon.spawnPlayerRight(true)
        end
        gameManager.gameModeSettings.doveLaunchDelayBool = true
        print('wait added before next launch of dove')
    end
end

function gameManager.restartGame()
    gameManager.list.gameOver = false
    gameOver = false
end

function gameManager.manageGameModeText()
    if gameModeCounter == 0 then
        gameModeText = '*Free Play*'
        --publicGameState = gameManager.gameState.freePlay
    elseif gameModeCounter == 1 then
        gameModeText = '*Championship*'
        --publicGameState = gameManager.gameState.championship
    elseif gameModeCounter == 2 then
        gameModeText = '*Options*'
        --publicGameState = gameManager.gameState.knitting
    end
    -- gameManager.gameState.current = gameManager.gameState.freePlay
    -- gameManager.gameState.current = gameManager.gameState.championship
    -- gameManager.gameState.current = gameManager.gameState.knitting
end




return gameManager
