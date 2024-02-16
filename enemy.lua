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
    for _, e in ipairs(enemy.list) do
        -- Enemy update logic
    end
end

function enemy.draw()
    for _, e in ipairs(enemy.list) do
        -- Enemy drawing logic
        love.graphics.draw(e.sprite, e.x, e.y)
    end
end

function  love.keypressed(key)
    if key == 'q' then
        print('adding enemy...')
        --bullet.x = shotgun.bulletSpawnX
        --bullet.y = shotgun.bulletSpawnY
        enemy.create(math.random(10, 120), math.random(10, 90))
    end
end

return enemy
