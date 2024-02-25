--inLoveParticles.lua

local inLoveParticles = {}

function inLoveParticles.load()
    inLoveParticles.list = {} -- list of particles
    inLoveParticles.createSimple(50, 50)
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
        duration = 3
    }
    table.insert(inLoveParticles.list, newParticle)

end

function inLoveParticles.simpleDropMove(dt)
    --todo: make particle go a little up, a little left and then drop...
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        particle.x = particle.x + 50 * dt
        particle.y = particle.y + 100 * dt
    end
end

function inLoveParticles.drawParticles()
    --love.graphics.rectangle('fill', 50, 50, 1,1)
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        print('...')
        love.graphics.rectangle('fill', particle.x, particle.y, 1,1)
    end
end

return inLoveParticles