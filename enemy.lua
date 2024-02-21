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
    --we are looping through it in reverse order, since the remove enemy from list part was causing a issue where the code exploded.
    for index = #enemy.list, 1, -1 do
        local enemyInstance = enemy.list[index]
        local fallSpeed = 0--50
        local moveSpeed = 0--100
        -- Update enemy logic
        enemyInstance.x = enemyInstance.x + moveSpeed * dt
        enemyInstance.y = enemyInstance.y + fallSpeed * dt

        -- Remove enemy if out of bounds
        if enemyInstance.x < 0 or enemyInstance.x > 128 then
            table.remove(enemy.list, index)
            print('Removing clayDove at index ' .. index)
        end
    end
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end


function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end


return enemy
