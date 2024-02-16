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
        sprite = love.graphics.newImage('sprites/clayDove.png')
        -- Additional enemy properties and initialization
    }
    table.insert(enemy.list, newEnemy)
    return newEnemy
end

function enemy.update(dt)
    for _, enemy in ipairs(enemy.list) do
        -- Enemy update logic
        enemy.x = enemy.x + 0.1 + dt
        --qe.y = e.y + 0.1 + dt
    end
end

function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end


return enemy
