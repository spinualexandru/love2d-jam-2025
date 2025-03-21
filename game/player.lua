local physics = require('game.physics')
local graphics = require('engine.graphics')
local ecs = require('engine.ecs')
local hud = require('engine.hud')

local player = {
    keyboard = {
        currentKeyPressed = nil,
    }
}

function player.load()
    -- Ensure physics.world is initialized
    if not physics.world then
        error("Physics world is not initialized. Call physics.load() before player.load().")
    end

    -- Create the player entity
    ecs.createEntity("player", {
        position = { x = 16 * 3, y = graphics.getScreenHeight() - 60 * 3 },
        size = { width = 32, height = 50 },
        velocity = { x = 0, y = 0 },
        direction = 1, -- 1 for right, -1 for left
        physics = {
            body = love.physics.newBody(physics.world, 16 * 3, graphics.getScreenHeight() - 60 * 3, "dynamic"),
            shape = love.physics.newRectangleShape(32, 50),
            fixture = nil
        },
        jumpCount = 0,
        image = love.graphics.newImage("assets/player.png"),
        damping = 5, -- Linear damping to reduce sliding
        friction = 0.8, -- Friction to reduce sliding on surfaces
        stamina = {
            max = 100,
            current = 100,
            regenRate = 5,
            isRegenerating = false
        },
        health = {
            max = 100,
            current = 100,
            regenRate = 0.1,
            isRegenerating = false
        },
        dash = {
            cooldown = 1, -- Cooldown time in seconds
            staminaCost = 33.3333 -- Stamina cost for dashing
        },
        points = {
            current = 0,
            multiplier = 1,
        },
        scale = {
            x = 2,
            y = 2
        },
        rotation = 0 -- Add rotation component
    })

    -- Initialize the player's physics components
    local playerEntity = ecs.getEntitiesByType("player")[1]
    local physics = playerEntity.components.physics
    physics.body:setFixedRotation(true)
    physics.body:setLinearDamping(playerEntity.components.damping)
    physics.fixture = love.physics.newFixture(physics.body, physics.shape)
    physics.fixture:setUserData("player")
    physics.fixture:setFriction(playerEntity.components.friction)
end

function player.unload()
    -- Clear the player entity
    ecs.removeAllEntitiesOfType("player")
end

function player.getStamina()
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        return playerEntity.components.stamina.current
    end
    return 0
end

function player.setStamina(value)
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        playerEntity.components.stamina.current = math.max(0, math.min(value, playerEntity.components.stamina.max))
    end
end

function player.getHealth()
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        return playerEntity.components.health.current
    end
    return 0
end

function player.setHealth(value)
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        playerEntity.components.health.current = math.max(0, math.min(value, playerEntity.components.health.max))
    end
end

function player.getPoints()
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        return playerEntity.components.points.current
    end
    return 0
end

function player.addPoints(value)
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        playerEntity.components.points.current = playerEntity.components.points.current + value * playerEntity.components.points.multiplier
    end
end

ecs.createSystem("playerMovement", { "position", "velocity", "direction", "physics", "jumpCount" }, function(dt, entity)
    if entity.type ~= "player" then
        return
    end
    local physics = entity.components.physics
    local body = physics.body
    local velocity = entity.components.velocity
    -- set gravity
    body:setGravityScale(3)
    -- Horizontal movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        body:setX(math.max(body:getX() - 200 * dt, 26 * 3))
        entity.components.direction = -1
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        body:setX(math.min(body:getX() + 200 * dt, graphics.getScreenWidth() - 32 * 3))
        entity.components.direction = 1
    end
end, "update")

ecs.createSystem("playerJump", { "physics", "jumpCount", "scale", "rotation" }, function(key, scancode, isRepeat, entity)
    if entity.type ~= "player" then
        return
    end
    local physics = entity.components.physics
    local body = physics.body
    local scale = entity.components.scale

    if key == "space" and entity.components.jumpCount < 2 then
        if entity.components.jumpCount == 0 then
            -- First jump
            body:applyLinearImpulse(0, -1000)
        else
            if entity.components.jumpCount == 1 then
                -- Second jump (double jump)
                body:applyLinearImpulse(0, -1000)
                entity.components.rotation = 0 -- Reset rotation
                entity.components.isFlipping = true -- Start flipping
            end
        end

        -- Apply bounce effect
        scale.x = 1.8
        scale.y = 2.2
        print("Key pressed for jump")

        love.audio.play(love.audio.newSource("assets/fall.wav", "static"))
        entity.components.jumpCount = entity.components.jumpCount + 1
    end
end, "input")

ecs.createSystem("playerDash", { "physics", "direction", "dash", "stamina" }, function(key, scancode, isRepeat, entity)
    if entity.type ~= "player" then
        return
    end
    local physics = entity.components.physics
    local body = physics.body
    local dash = entity.components.dash
    local stamina = entity.components.stamina

    if key == "lshift" and not isRepeat then
        if stamina.current >= dash.staminaCost then
            dashCooldown = 1
            local dashImpulse = 1000 * entity.components.direction
            body:applyLinearImpulse(dashImpulse, 0)
            stamina.current = stamina.current - dash.staminaCost
            love.audio.play(love.audio.newSource("assets/fall.wav", "static"))
        else
            hud.announcement("Not enough stamina to dash!", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end
    end
end, "input")

ecs.createSystem("playerStaminaRegen", { "stamina" }, function(dt, entity)
    if entity.type ~= "player" then
        return
    end
    local stamina = entity.components.stamina
    if stamina.current < stamina.max then
        stamina.current = math.min(stamina.current + stamina.regenRate * dt, stamina.max)
    end
end, "update")

function player.getPosition()
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        local physics = playerEntity.components.physics
        return physics.body:getX(), physics.body:getY()
    end
    return nil, nil
end

ecs.createSystem("playerRender", { "position", "size", "direction", "image", "physics", "scale", "rotation" }, function(entity)
    if entity.type ~= "player" then
        return
    end
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    local physics = entity.components.physics
    local body = physics.body
    local image = entity.components.image
    local direction = entity.components.direction
    local scale = entity.components.scale
    local rotation = entity.components.rotation

    -- Adjust scale based on vertical velocity
    local vy = body:getLinearVelocity()
    if vy < 0 then
        -- Narrower and taller when jumping
        scale.x = 1.6
        scale.y = 2.2
    elseif vy > 0 then
        -- Wider and less tall when falling
        scale.x = 2.2
        scale.y = 1.8
    end

    if entity.components.isFlipping then
        entity.components.rotation = entity.components.rotation + (math.pi * 3.5 * love.timer.getDelta())
        if entity.components.rotation >= math.pi * 2 then
            entity.components.rotation = 0
            entity.components.isFlipping = false -- Stop flipping
        end
    end

    -- Draw the player image centered on the player's position with rotation
    local px, py = body:getPosition()
    love.graphics.draw(image, px, py, rotation, scale.x * direction, scale.y, image:getWidth() / 2, image:getHeight() / 2)

end, "render")

function player.beginContact(a, b, coll)
    local userDataA = a:getUserData()
    local userDataB = b:getUserData()

    -- Reset jump count and scale if the player lands
    if userDataA == "player" or userDataB == "player" then
        local playerEntity = ecs.getEntitiesByType("player")[1]
        playerEntity.components.jumpCount = 0
        playerEntity.components.scale.x = 2
        playerEntity.components.scale.y = 2
    end
end

function player.endContact(a, b, coll)
    -- Logic for when objects stop colliding (if needed)
end

function player.resetJumpCount()
    local playerEntity = ecs.getEntitiesByType("player")[1]
    if playerEntity then
        playerEntity.components.jumpCount = 0
    end
end

return player
