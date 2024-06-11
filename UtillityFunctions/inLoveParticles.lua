--inLoveParticles.lua

local inLoveParticles = {}
local inLoveColors = require "UtillityFunctions.inLoveColors"

--TOOD: do effect like hoi amigo

function inLoveParticles.load()
    inLoveParticles.list = {} -- list of particles
    -- inLoveParticles.createSimple(50, 50, 'right')
    -- inLoveParticles.createSimple(50, 50, 'left')
    -- inLoveParticles.createSimple(55, 50, 'right')
    -- inLoveParticles.createSimple(55, 50, 'left')
end

function inLoveParticles.update(dt)
    inLoveParticles.simpleDropMove(dt)
end

function inLoveParticles.draw()
    --love.graphics.rectangle('fill', 50, 50, 1,1)
    inLoveParticles.drawParticles()
end

function inLoveParticles.removeParticle(index)
    table.remove(inLoveParticles.list, index)
end


function inLoveParticles.createSimple(x, y, direction)
    local newParticle = {
        x = x,
        y = y,
        duration = 0.2,
        direction = direction --math.random() < 0.5 and 'left' or 'right'
    }
    table.insert(inLoveParticles.list, newParticle)

end

function inLoveParticles.simpleDropMove(dt)
    --todo: make particle go a little up, a little left and then drop...
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        --decrease duration so we racha 0 at some point and can kill it
        particle.duration = particle.duration - dt
        --if we are above 0.3 secounds left we want the particle to move in a arch form
        if particle.duration >= 0.1 then
            --move the particle left
            if particle.direction == 'left' then
                particle.x = particle.x - math.random(40,150) * dt
            --else move it right
            else
                particle.x = particle.x + math.random(40,200) * dt
            end
            --make the particle go upwards
            particle.y = particle.y - math.random(60,80) * dt
        --if we have less than 0.3 secounds left we want the particle to drop
        else
            --move the particle left
            if particle.direction == 'left' then
                particle.x = particle.x - math.random(12,30) * dt
            --else move it right
            else
                particle.x = particle.x + math.random(12,30) * dt
            end
            --make the particle fall (move down)
            particle.y = particle.y + math.random(130,350) * dt
        end

        --if the duration is less than 0 we want to remove it
        if particle.duration <= 0 then
            inLoveParticles.removeParticle(particleIndex)
        end
    end
end

function inLoveParticles.drawParticles()
    --love.graphics.rectangle('fill', 50, 50, 1,1)
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        inLoveColors.ColorPalette_pico8Micro('pink')
        love.graphics.rectangle('fill', particle.x, particle.y, 2,2)
        inLoveColors.ColorPalette_pico8Micro('white')
    end
end

return inLoveParticles