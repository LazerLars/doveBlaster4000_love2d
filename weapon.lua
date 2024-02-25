-- weapon.lua
local weapon = {}

function weapon.load()
    -- Weapon initialization logic
    --weapon.shotgun = {}
    weapon.specs = {
        spawnPosX = 64
    }
    weapon.bulletList = {}
    -- shotgun = love.graphics.newImage('sprites/shotgun_8x8.png')
    -- bulletSpawnX = 
    
    
    weapon.gun = {
        spr_shotgun = love.graphics.newImage('sprites/guns/shotgun2_8x8.png'),
        
        bulletSpawnX = 0,
        bulletSpawnY = 0,
        spr_bullet = love.graphics.newImage('sprites/bullets/bullet1_8x8.png'),
        
        spr_shellMagazine = love.graphics.newImage('sprites/shells/shell1.png'),
        spr_gunShell = love.graphics.newImage('sprites/shells/shell3_small.png'),
    }
end

function weapon.update(dt)
    -- Weapon update logi
    weapon.moveBullet(dt)
end

function weapon.draw()
    -- Weapon drawing logic
    weapon.pointGunToCursor(weapon.specs.spawnPosX)

    --love.graphics.rectangle('fill', bullet.x, bullet.y, 4, 4)
    weapon.drawBullet()
    
    --draw shells
    love.graphics.draw(weapon.gun.spr_gunShell, 90, 102,0,1,1)
    love.graphics.draw(weapon.gun.spr_shellMagazine, 105, 102,0,2,2)
    love.graphics.draw(weapon.gun.spr_shellMagazine, 105, 110,0,2,2)
    
end

function weapon.pointGunToCursor(startPos)
    --placement of gun
    local weaponX, weaponY = startPos, 128 - 8 -- Adjust these values based on your weapon's position
    --used for determine if we need to flip the gun vertically
    local flip
    -- Determine if the sprite should be flipped based on mouse position
    --flip = -1 will flip vertically
    if mouseX < startPos-1 then
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
        weapon.gun.bulletSpawnX = barrelPointX -4
        weapon.gun.bulletSpawnY = barrelPointY +1
    --if our sprite is flipped vertically
    elseif flip > 0 then
        barrelPointX = weaponX + rotatedBarrelOffsetX * flip -- Adjust for flipping
        weapon.gun.bulletSpawnX = barrelPointX -1
        weapon.gun.bulletSpawnY = barrelPointY - 3
    end
   
    -- Draw the sprite with appropriate flipping
    love.graphics.draw(weapon.gun.spr_shotgun, weaponX, weaponY, math.rad(angleDegrees), 1, flip, 0, 0)
end

function weapon.addBullet()
    local spawnX, spawnY = weapon.gun.bulletSpawnX, weapon.gun.bulletSpawnY
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
        speed = 800,
        w = 5,
        h = 3

    }
    table.insert(weapon.bulletList, bullet)
    local sfx_shoot = love.audio.newSource('sfx/sfx_fire.mp3', 'stream')
    love.audio.play(sfx_shoot)
    sfx_shoot:play()
    --print('adding bullet, new length: ' .. #bulletList)
end

function weapon.removeBullet(index)
    table.remove(weapon.bulletList, index)
end

function weapon.moveBullet(dt)
    for bulletIndex, bullet in ipairs(weapon.bulletList) do
        local dx = math.cos(bullet.angleRadians) * bullet.speed * dt -- Multiply by dt for frame independence
        local dy = math.sin(bullet.angleRadians) * bullet.speed * dt

        bullet.x = bullet.x + dx
        bullet.y = bullet.y + dy

        weapon.removeBulletOutOfScreen(bullet, bulletIndex)
    end
end

function weapon.removeBulletOutOfScreen(bullet, bulletIndex)
    if bullet.x < 0 or bullet.x > screenWidth or
           bullet.y < 0 or bullet.y > screenHeight then
            --table.remove(weapon.bulletList, index)
            weapon.removeBullet(bulletIndex)
            print('removing bullet, out of bounds. bulletIndex: ' .. bulletIndex)
        end
end

function weapon.drawBullet()
        for index, bullet in ipairs(weapon.bulletList) do
            love.graphics.draw(weapon.gun.spr_bullet,bullet.x, bullet.y)
        end    
end

function weapon.setGunStartPosX(posX)
    weapon.specs.spawnPosX = posX
end

return weapon

