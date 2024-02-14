-- weapon.lua

local weapon = {}

function weapon.load()
    -- Weapon initialization logic
    shotgun = love.graphics.newImage('sprites/shotgun.png')
end

function weapon.update(dt)
    -- Weapon update logic
end

function weapon.draw()
    love.graphics.draw(shotgun, 0, 0)
    -- Weapon drawing logic
end

return weapon
