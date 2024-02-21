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
    enemy.moveDove(dt)
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end

function enemy.moveDove(dt)
    for doveIndex, dove in ipairs(enemy.list) do
        local fallSpeed = 50
        local moveSpeed = 100
        -- Update enemy logic
        dove.x = dove.x + moveSpeed * dt
        dove.y = dove.y + fallSpeed * dt

        -- Remove enemy if out of bounds
        if dove.x < 0 or dove.x > 128 then
            --table.remove(enemy.list, index)
            enemy.remove(doveIndex)
            print('Removing clayDove exited screen. Doveindex: ' .. doveIndex)
        end
    end
end



function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end


return enemy
