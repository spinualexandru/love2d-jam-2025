local ecs = require('engine.ecs')
local energyBall = require('game.energy_ball')
local button = require('game.button')
local mathPlus = require('engine.math')
local player = require('game.player')
local portal = {}
local lastShootTime = 0
local shootInterval = math.random(2, 5)

function portal.load()
    ecs.createEntity("portal", {
        type = "portal",
        name = "portal",
        position = { x = (love.graphics.getWidth() / 2) - 12, y = 40 },
        size = { width = 100, height = 94 },
        image = love.graphics.newImage("assets/portal.png")
    })

    ecs.createEntity("portal", {
        type = "portal",
        name = "portal",
        position = { x = (love.graphics.getWidth() / 2) + 200 - 12, y = 40 },
        size = { width = 100, height = 94 },
        image = love.graphics.newImage("assets/portal.png")
    })

    ecs.createEntity("portal", {
        type = "portal",
        name = "portal",
        position = { x = (love.graphics.getWidth() / 2) - 200 + 12, y = 40 },
        size = { width = 100, height = 94 },
        image = love.graphics.newImage("assets/portal.png")
    })
end

ecs.createSystem("portalShoot", { "position" }, function(dt, entity)
    if entity.type ~= "portal" then
        return
    end

    local currentTime = love.timer.getTime()
    if currentTime - lastShootTime >= shootInterval then
        lastShootTime = currentTime
        shootInterval = math.random(2, 5)

        local buttons = ecs.getEntitiesByType("button")
        if #buttons > 0 then
            local targetButton = buttons[math.random(#buttons)]
            local targetPosition = targetButton.components.position
            energyBall.spawn(entity.components.position, targetPosition)
        end
    end

    -- destroy the energy ball if it's in the range of one of the buttons
    local energyBalls = ecs.getEntitiesByType("energy_ball")
    for _, energyBallEntity in ipairs(energyBalls) do
        local energyBallX = energyBallEntity.components.position.x
        local energyBallY = energyBallEntity.components.position.y
        local buttons = ecs.getEntitiesByType("button")
        for _, buttonEntity in ipairs(buttons) do
            local buttonX = buttonEntity.components.position.x
            local buttonY = buttonEntity.components.position.y
            local buttonWidth = buttonEntity.components.size.width
            local buttonHeight = buttonEntity.components.size.height
            if mathPlus.aabbCollision(energyBallX, energyBallY, 10, 10, buttonX, buttonY, buttonWidth, buttonHeight) then
                -- Check if the player is in range of the energy ball
                local playerEntity = ecs.getEntitiesByType("player")[1]
                local playerX, playerY = player.getPosition()

                -- Calculate the distance between the energy ball and the player
                local distance = mathPlus.distance(energyBallX, energyBallY, playerX, playerY)
                local threshold = 50 -- Define a threshold distance for the collision

                if distance <= threshold then
                    player.addPoints(1)
                    print("Player points: " .. player.getPoints())
                else
                    player.setHealth(player.getHealth() - 10)
                    print("Player health: " .. player.getHealth())
                end

                ecs.removeEntity(energyBallEntity)
            end
        end
    end
end, "update")

ecs.createSystem("portalRender", { "position", "size", "image" }, function(entity)
    if entity.type ~= "portal" then
        return
    end
    love.graphics.setColor(1, 1, 1)
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    love.graphics.draw(entity.components.image, x, y, 0, 4, 4)
end, "render")

return portal