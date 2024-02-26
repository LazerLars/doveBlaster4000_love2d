--inLoveParticles.lua

local inLoveParticles = {}

function inLoveParticles.load()
    inLoveParticles.list = {} -- list of particles
    inLoveParticles.createSimple(50, 50)
    inLoveParticles.createSimple(25, 25)
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


function inLoveParticles.createSimple(x, y)
    local newParticle = {
        x = x,
        y = y,
        duration = 0.5
    }
    table.insert(inLoveParticles.list, newParticle)

end

function inLoveParticles.simpleDropMove(dt)
    --todo: make particle go a little up, a little left and then drop...
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        particle.duration = particle.duration - dt
        
        if particle.duration >= 0.3 then
            particle.x = particle.x - math.random(40,100) * dt
            particle.y = particle.y - math.random(60,120) * dt
        else
            particle.x = particle.x - math.random(12,30) * dt
            particle.y = particle.y + math.random(130,350) * dt

        end

        if particle.duration <= 0 then
            print('die particle')
            inLoveParticles.removeParticle(particleIndex)
        end
    end
end

function inLoveParticles.drawParticles()
    --love.graphics.rectangle('fill', 50, 50, 1,1)
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        print('...')
        love.graphics.rectangle('fill', particle.x, particle.y, 5,5)
    end
end

return inLoveParticles