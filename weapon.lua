-- weapon.lua

local weapon = {}

--we need maid64 to get the mouse position in the right scaled format 
local maid64 = require "maid64"

function weapon.load()
    -- Weapon initialization logic
    shotgun = love.graphics.newImage('sprites/shotgun_8x8.png')
end

function weapon.update(dt)
    -- Weapon update logic
end

function weapon.draw()
    --love.graphics.draw(shotgun, 90, 128-16)
    -- Weapon drawing logic
    weapon.pointGunToCursor()
end

function weapon.pointGunToCursor()
    local mouseX, mouseY = maid64.mouse.getPosition()  --maid64.mouse.getX(),  maid64.mouse.getY()
    local weaponX, weaponY = 64, 128 - 8 -- Adjust these values based on your weapon's position
    local flip

    -- Determine if the sprite should be flipped based on mouse position
    --flip = -1 will flip horizontally
    if mouseX < 63 then
        flip = -1
        --flip = 1
    else
        flip = 1
    end
    -- print('mouseX:' .. mouseX)
    -- print('mouseY:' .. mouseY)
    -- print('flip..' .. flip)

    --i want the gun barrol to face towards the cursor. 
    --gun is 8x8 and barrol are placed at x=8,y=1&2&3'
    --you need to take into account that the sprite can be flipped. 
     -- Calculate the angle between the weapon's barrel and the cursor
     local barrelOffsetX, barrelOffsetY = 8, 2  -- Offset of the gun barrel from the weapon's position
     local angleRadians = math.atan2(mouseY - (weaponY + barrelOffsetY), mouseX - (weaponX + (flip == -1 and barrelOffsetX or 0)))
     local angleDegrees = angleRadians * (180 / math.pi)
     angleDegrees = math.floor(angleDegrees)
    love.graphics.print(angleDegrees,0,8)
    -- Draw the sprite with appropriate flipping
    love.graphics.draw(shotgun, weaponX, weaponY, math.rad(angleDegrees), 1, flip, 0, 0)
    --love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
end


return weapon
