local physics = {}
local lovePhysics = love.physics


physics.world = nil -- Declare the physics world

function physics.load()
    -- Initialize the physics world with gravity
    physics.world = lovePhysics.newWorld(0, 500, true) -- Gravity set to 500 in the y-axis
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

    -- Reset jump count if the player lands
    if userDataA == "player" or userDataB == "player" then
        require('game.player').resetJumpCount()
    end
end

function physics.endContact(a, b, coll)
    -- Logic for when objects stop colliding (if needed)
end

return physics
