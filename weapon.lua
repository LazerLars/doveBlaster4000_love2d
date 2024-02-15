-- weapon.lua

local weapon = {}

local shotgun = {}

local bullet = {}

--we need maid64 to get the mouse position in the right scaled format 
local maid64 = require "maid64"

function weapon.load()
    -- Weapon initialization logic
    -- shotgun = love.graphics.newImage('sprites/shotgun_8x8.png')
    -- bulletSpawnX = 

    shotgun = {
        spr_shotgun = love.graphics.newImage('sprites/shotgun_8x8.png'),
        bulletSpawnX = 0,
        bulletSpawnY = 0,
    }

    bullet = {
        x = 0,
        y = 0
    }
end

function weapon.update(dt)
    -- Weapon update logic
end

function weapon.draw()
    --love.graphics.draw(shotgun, 90, 128-16)
    -- Weapon drawing logic
    weapon.pointGunToCursor()

    love.graphics.rectangle('fill', bullet.x, bullet.y, 4, 4)
    
end

function weapon.pointGunToCursor()
    local mouseX, mouseY = maid64.mouse.getPosition()
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

    shotgun.bulletSpawnX = barrelPointX
    shotgun.bulletSpawnY = barrelPointY
    --------------------------------
    --------------------------------

    -- Print the current coordinates of the barrel
    love.graphics.print('bum: ' .. math.floor(barrelPointX) .. "," .. math.floor(barrelPointY) , 0, 17)
    love.graphics.print('Degrees: ' .. angleDegrees, 0, 9)

    -- Draw the sprite with appropriate flipping
    love.graphics.draw(shotgun.spr_shotgun, weaponX, weaponY, math.rad(angleDegrees), 1, flip, 0, 0)
end

function  love.keypressed(key)
    if key == 'space' then
        print('FIRE in the HOLE ' .. shotgun.bulletSpawnX .. "," .. shotgun.bulletSpawnY)
        bullet.x = shotgun.bulletSpawnX
        bullet.y = shotgun.bulletSpawnY
    end
	-- if key == 'p' then
	-- 	gunPos = gunPosRight
	-- 	local bullet = Bullet(bulletSpeed, 'right')
	-- 	table.insert(bulletsList, bullet)
	-- 	triggerScreenShake('right', 0.05)
	-- end
	-- if key == 'w' then
	-- 	gunPos = gunPosLeft
	-- 	local bullet = Bullet(bulletSpeed, 'left')
	-- 	table.insert(bulletsList, bullet)
	-- 	love.graphics.setBackgroundColor(255/255,119/255,168/255)
	-- 	triggerScreenShake('left', 0.05)
	-- end
	-- if key == 'e' then
	-- 	print('spawn enemy left')
	-- 	local enemy = Enemy('left', 60)
	-- 	table.insert(enemyList, enemy)
	-- end
	-- if key == 'o' then
	-- 	print('spawn enemy right')
	-- 	local enemy = Enemy('right', 50)
	-- 	table.insert(enemyList, enemy)
	-- end
end

return weapon

