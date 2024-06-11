-- enemy.lua

local enemy = {}

local weapon = require "weapon"

function enemy.load()
    -- Enemy initialization logic
    enemy.list = {}  -- List to store enemies
    enemy.doveCount = 0
    enemy.spawnCounter = 0
    enemy.switchSideDoveNumb = 5
    enemy.roundCount = 0
    -- enemy.clayDove = {
    --     x,
    --     y,
    --     sprite = love.graphics.newImage('sprites/clayDove.png')
    -- }
end

function enemy.create(x, y, spawnRightSide)
    local newEnemy = {
        x = x,
        y = y,
        --hard mode
        sprite = love.graphics.newImage('sprites/enemies/clayDove.png'),
        --easy mode
        -- sprite = love.graphics.newImage('sprites/enemies/clayDove7.png'),
        --hard mode
        w = 5,
        h = 3,
        --easy mode
        -- w = 7,
        -- h = 5,
        spawnRightSide = spawnRightSide
        -- Additional enemy properties and initialization
    }
    table.insert(enemy.list, newEnemy)
    enemy.doveCount = enemy.doveCount + 1
    enemy.spawnCounter = enemy.spawnCounter + 1
    return newEnemy
end

-- spawn a clay dove on the left side of the screen
function enemy.createEnemyOnLeft()
    enemy.create(8, math.random(80,124), false)
end

--spawn a clay dove on the right side of the screen
function enemy.createEnemyOnRight()
    enemy.create(120, math.random(80,124), true)
end

function enemy.update(dt)
    enemy.moveDove(dt, false)
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end

function enemy.moveDove(dt, static)
    for doveIndex, dove in ipairs(enemy.list) do
        local fallSpeed = math.random(-40,-120) -- between 40 & 120, -40  & -120,(- moves up, + moves down )
        local moveSpeed = -100 -- (- moves left, + moves right)
        if dove.spawnRightSide == true then
            fallSpeed = math.random(-40,-120) -- between 40 & 120, -40  & -120,(- moves up, + moves down )
            moveSpeed = math.random(-100,-200) -- -100 -- (- moves left, + moves right)
        else
            fallSpeed = math.random(-40,-120)
            moveSpeed = math.random(100,200)
        end
        
        if static == true then
            fallSpeed = 0
            moveSpeed = 0
        end
        -- Update enemy logic
        dove.x = dove.x + moveSpeed * dt
        dove.y = dove.y + fallSpeed * dt

       enemy.removeDovesOutOfScreenOnXaxis(dove, doveIndex)
    end
end

function enemy.removeDovesOutOfScreenOnXaxis(dove, doveIndex)
     -- Remove enemy if out of bounds
     --we only look at the x axis since we want to allow dove to go out of y and come backinto the screen
     if dove.x < 0 or dove.x > 128 then
        --table.remove(enemy.list, index)
        enemy.remove(doveIndex)
    end
end


function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end

function enemy.playSfx_enemyDead()
    local sfx_shoot = love.audio.newSource('sfx/sfx_pop.mp3', 'stream')
    love.audio.play(sfx_shoot)
    sfx_shoot:play()
end


return enemy
