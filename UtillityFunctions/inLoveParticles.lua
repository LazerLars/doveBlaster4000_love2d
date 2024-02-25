--inLoveParticles.lua

local inLoveParticles = {}

function inLoveParticles.load()
    inLoveParticles.list = {} -- list of particles
end

function inLoveParticles.update(dt)

end

function inLoveParticles.draw()
    love.graphics.rectangle('fill', 50, 50, 1,1)
    for particleIndex, particle in ipairs(inLoveParticles.list) do
        print('...')
    end
end

function inLoveParticles.removeParticle(index)
    table.remove(inLoveParticles.list, index)
end


function inLoveParticles.createSimple()

end

function inLoveParticles.simpleDropMove()

end

function inLoveParticles.drawParticles()

end

return inLoveParticles