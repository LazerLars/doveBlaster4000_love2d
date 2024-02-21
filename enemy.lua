-- enemy.lua

local enemy = {}

function enemy.load()
    -- Enemy initialization logic
    enemy.list = {}  -- List to store enemies

    -- enemy.clayDove = {
    --     x,
    --     y,
    --     sprite = love.graphics.newImage('sprites/clayDove.png')
    -- }
end

function enemy.create(x, y)
    local newEnemy = {
        x = x,
        y = y,
        sprite = love.graphics.newImage('sprites/enemies/clayDove.png'),
        w = 5,
        h = 3
        -- Additional enemy properties and initialization
    }
    table.insert(enemy.list, newEnemy)
    return newEnemy
end

function enemy.update(dt)
    enemy.moveDove(dt, true)
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end

function enemy.moveDove(dt, static)
    for doveIndex, dove in ipairs(enemy.list) do
        local fallSpeed = 50
        local moveSpeed = 100
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
        print('Removing clayDove exited screen. Doveindex: ' .. doveIndex)
    end
end


function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end


return enemy
