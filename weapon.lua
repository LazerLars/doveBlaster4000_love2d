-- weapon.lua
local weapon = {}

--local shotgun = {}

--local bulletList = {}
local spr_bullet, spr_shellMagazine, spr_gunShell

--we need maid64 to get the mouse position in the right scaled format 
local maid64 = require "maid64"

function weapon.load()
    -- Weapon initialization logic
    --weapon.shotgun = {}
    weapon.bulletList = {}
    -- shotgun = love.graphics.newImage('sprites/shotgun_8x8.png')
    -- bulletSpawnX = 
    spr_bullet = love.graphics.newImage('sprites/bullets/bullet1_8x8.png')
    spr_shellMagazine = love.graphics.newImage('sprites/shells/shell1.png')
    spr_gunShell = love.graphics.newImage('sprites/shells/shell3_small.png')
    
    weapon.shotgun = {
        spr_shotgun = love.graphics.newImage('sprites/guns/shotgun_8x8.png'),
        bulletSpawnX = 0,
        bulletSpawnY = 0,
    }

end

function weapon.update(dt)
    -- Weapon update logic

    weapon.moveBullet(dt)
end

function weapon.draw()
    --love.graphics.draw(shotgun, 90, 128-16)
    -- Weapon drawing logic
    weapon.pointGunToCursor()

    --love.graphics.rectangle('fill', bullet.x, bullet.y, 4, 4)
    weapon.drawBullet()
    
    --draw shells
    love.graphics.draw(spr_gunShell, 90, 102,0,1,1)
    love.graphics.draw(spr_shellMagazine, 105, 102,0,2,2)
    love.graphics.draw(spr_shellMagazine, 105, 110,0,2,2)
    
end

function weapon.pointGunToCursor()
    --placement of gun
    local weaponX, weaponY = 64, 128 - 8 -- Adjust these values based on your weapon's position
    --used for determine if we need to flip the gun vertically
    local flip

    -- Determine if the sprite should be flipped based on mouse position
    --flip = -1 will flip vertically
    if mouseX < 63 then
        flip = -1
    else
        flip = 1
    end

    
    -- Offset of the gun barrel from the weapon's position
    local barrelOffsetX, barrelOffsetY = 8, 2

    -- Calculate the angle between the weapon's barrel and the cursor
    local angleRadians = math.atan2(mouseY - (weaponY + barrelOffsetY), mouseX - (weaponX + (flip == -1 and barrelOffsetX or 0)))
    --degrees because thats what we like
    local angleDegrees = math.floor(math.deg(angleRadians))

    --------------------------------
    -- Calculate the point where the barrel is in the world now
    --this will be the bullet spawnPoint
    --------------------------------
    local rotatedBarrelOffsetX = barrelOffsetX * math.cos(angleRadians) - barrelOffsetY * math.sin(angleRadians)
    local rotatedBarrelOffsetY = barrelOffsetX * math.sin(angleRadians) + barrelOffsetY * math.cos(angleRadians)
    local barrelPointX = weaponX + rotatedBarrelOffsetX * -flip
    local barrelPointY = weaponY + rotatedBarrelOffsetY
    barrelOffsetY = math.floor(barrelOffsetY)
    --we need to calculate the barrolPointX according to the way the sprite are flipped
    if flip < 0 then
        barrelPointX = weaponX + rotatedBarrelOffsetX * -flip -- Adjust for flipping    
    elseif flip > 0 then
        barrelPointX = weaponX + rotatedBarrelOffsetX * flip -- Adjust for flipping
    end
    barrelOffsetX = math.floor(barrelOffsetX)

    --bullet spawn point needs to be adjusted
    --if our sprite is normal placed
    if flip < 0 then
        barrelPointX = weaponX + rotatedBarrelOffsetX * -flip -- Adjust for flipping    
        weapon.shotgun.bulletSpawnX = barrelPointX -4
        weapon.shotgun.bulletSpawnY = barrelPointY +1
    --if our sprite is flipped vertically
    elseif flip > 0 then
        barrelPointX = weaponX + rotatedBarrelOffsetX * flip -- Adjust for flipping
        weapon.shotgun.bulletSpawnX = barrelPointX -1
        weapon.shotgun.bulletSpawnY = barrelPointY - 3
    end
    --------------------------------
    --------------------------------

    -- Print the current coordinates of the barrel
    --love.graphics.print('bum: ' .. math.floor(barrelPointX) .. "," .. math.floor(barrelPointY) , 0, 17)
    --love.graphics.print('Degrees: ' .. angleDegrees, 0, 9)

    -- Draw the sprite with appropriate flipping
    love.graphics.draw(weapon.shotgun.spr_shotgun, weaponX, weaponY, math.rad(angleDegrees), 1, flip, 0, 0)
end

-- function  love.keypressed(key)
--     if key == 'space' then
--         print('FIRE in the HOLE ' .. shotgun.bulletSpawnX .. "," .. shotgun.bulletSpawnY)
--         --bullet.x = shotgun.bulletSpawnX
--         --bullet.y = shotgun.bulletSpawnY
--         weapon.addBullet(shotgun.bulletSpawnX, shotgun.bulletSpawnY, 0)
--     end
--     if key == 'q' then
--         print('adding enemy...')
--         --bullet.x = shotgun.bulletSpawnX
--         --bullet.y = shotgun.bulletSpawnY
--         --enemy.create(math.random(10, 120), math.random(10, 90))
--     end
-- end

function weapon.addBullet()
    local spawnX, spawnY = weapon.shotgun.bulletSpawnX, weapon.shotgun.bulletSpawnY
    local angleRadians = math.atan2(mouseY - spawnY, mouseX - spawnX)
    --local angleDegrees = math.floor(math.deg(angleRadians))
    local angleDegrees = math.deg(angleRadians)
    --print (angleDegrees)
    --lets add some recoil to the bullets
    local random = math.random(-1, -4)
    angleDegrees = angleDegrees + random
    --angleRadians = math.rad(angleDegrees)
    local bullet = {
        x = spawnX,
        y = spawnY,
        angleRadians = angleRadians,
        --degrees because thats what we like
        angleDegrees = angleDegrees,
        speed = 100,
        w = 5,
        h = 3

    }
    table.insert(weapon.bulletList, bullet)
    --print('adding bullet, new length: ' .. #bulletList)
end

function weapon.moveBullet(dt)
    for index, bullet in ipairs(weapon.bulletList) do
        local dx = math.cos(bullet.angleRadians) * bullet.speed * dt -- Multiply by dt for frame independence
        local dy = math.sin(bullet.angleRadians) * bullet.speed * dt

        bullet.x = bullet.x + dx
        bullet.y = bullet.y + dy

        -- If bullet is out of bounds, remove it
        if bullet.x < 0 or bullet.x > screenWidth or
           bullet.y < 0 or bullet.y > screenHeight then
            table.remove(weapon.bulletList, index)
            print('removing bullet, out of bounds')
        end
    end
end


function weapon.drawBullet()
    --print(#weapon.bulletList)
    -- for index, bullet in ipairs(bulletList) do
    --     print(bullet.x)
    -- end
    --if #bulletList > 0 then
        for index, bullet in ipairs(weapon.bulletList) do
            --print('bullet numb: ' .. index .. ' bullet xY: ' .. bullet.x .. ',' .. bullet.y)
            --print(bullet.x)
            --print(bullet.y)
            --love.graphics.rectangle('fill', bullet.x, bullet.y, 4,4)
            love.graphics.draw(spr_bullet,bullet.x, bullet.y)
            --love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
            
        end    
    --end
    
end




return weapon

