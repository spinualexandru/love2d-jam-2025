local physics = {}
local lovePhysics = love.physics


physics.world = nil

function physics.load()
    physics.world = lovePhysics.newWorld(0, 500, true)
    physics.world:setCallbacks(physics.beginContact, physics.endContact)
    physics.world:setCallbacks(require('game.player').beginContact, require('game.player').endContact)
end

function physics.update(dt)
    if physics.world then
        physics.world:update(dt)
    end
end

function physics.beginContact(a, b, coll)
    local userDataA = a:getUserData()
    local userDataB = b:getUserData()


    if userDataA == "player" or userDataB == "player" then
        require('game.player').resetJumpCount()
    end
end

function physics.endContact(a, b, coll)

end

return physics
