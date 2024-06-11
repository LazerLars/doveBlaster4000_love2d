local inLoveJuicer = {}

function inLoveJuicer.load()
    inLoveJuicer.list = {
        shakeMagnitude = 3,  -- how much the screen shakes
        shakeTimer = 0,
        shakeOffsetX = 0,
        shakeOffsetY = 0,
        shakeDirection = ''
    }

end

function inLoveJuicer.update(dt)
	inLoveJuicer.screenShakeUpdate(dt)
end

function inLoveJuicer.triggerScreenShake(direction, shakeDuration)
    inLoveJuicer.list.shakeTimer = shakeDuration
	inLoveJuicer.list.shakeDirection = direction
end

function inLoveJuicer.screenShakeUpdate(dt)
	-- Update the screen shake effect
	if inLoveJuicer.list.shakeTimer > 0 then
		inLoveJuicer.list.shakeTimer = inLoveJuicer.list.shakeTimer - dt
		--shoot right
		if inLoveJuicer.list.shakeDirection == 'right' then			
			inLoveJuicer.list.shakeOffsetX = love.math.random(inLoveJuicer.list.shakeMagnitude, - inLoveJuicer.list.shakeMagnitude)
		end

		if inLoveJuicer.list.shakeDirection == 'left' then
			
			--shoot left
			inLoveJuicer.list.shakeOffsetX = love.math.random(-inLoveJuicer.list.shakeMagnitude, inLoveJuicer.list.shakeMagnitude)
		end

		if inLoveJuicer.list.shakeDirection == 'enemyDead' then
			--enemy dead
			inLoveJuicer.list.shakeOffsetX = love.math.random(inLoveJuicer.list.shakeMagnitude, -inLoveJuicer.list.shakeMagnitude)
			inLoveJuicer.list.shakeOffsetY = love.math.random(-inLoveJuicer.list.shakeMagnitude, inLoveJuicer.list.shakeMagnitude)	
		end
		
	else
		inLoveJuicer.list.shakeOffsetX = 0
		inLoveJuicer.list.shakeOffsetY = 0
	end
end

-- need to sorund the things you want to shake in the love.draw() with inLoveJuicer.drawStart() inLoveJuicer.drawEnd() 
function inLoveJuicer.drawStart()
    love.graphics.push()
    love.graphics.translate(inLoveJuicer.list.shakeOffsetX, inLoveJuicer.list.shakeOffsetY)
end

function inLoveJuicer.drawEnd()
	love.graphics.pop()
end

return inLoveJuicer