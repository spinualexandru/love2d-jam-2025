local ecs = require('engine.ecs')
local debug = require('libs.debug')
local mathPlus = require('engine.math')
local hud = require('engine.hud')
local player = require('game.player')
local button = {}
local buttonImage


function button.load()
    buttonImage = love.graphics.newImage("assets/button-round.png")
end

function button.create(x, y, width, height)
    if not width or not height then
        if buttonImage then
            width = buttonImage:getWidth()
            height = buttonImage:getHeight()
        else
            error("Button image not loaded. Call button.load() before creating a button.")
        end
    end


    local entity = ecs.createEntity("button", {
        position = { x = x, y = y },
        size = { width = width, height = height },
        state = {
            pressed = false,
            action = function()
                ecs.removeAllEntitiesOfType("announcement")

                hud.announcement("Button  pressed now " .. math.random(1, 100))
                hud.achievement("Clicked a button")
            end
        },

    })
end

ecs.createSystem("buttonRender", { "position", "size", "state" }, function(entity)
    if entity.type ~= "button" then return end
    local oldColor = { love.graphics.getColor() }
    love.graphics.setColor(1, 1, 1)
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height


    if buttonImage then
        love.graphics.draw(buttonImage, x, y, 0, 1, 1)
    else
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", x, y, width, height)
    end

    love.graphics.setColor(oldColor)
end, "render")


ecs.createSystem("buttonInteraction", { "position", "size", "state" }, function(dt, entity)
    if entity.type ~= "button" then return end

    local px, py = player.getPosition()
    local bx, by = entity.components.position.x, entity.components.position.y
    local bw, bh = entity.components.size.width, entity.components.size.height

    local playerWidth, playerHeight = 32, 50
    local playerRect = {
        x = px - playerWidth / 2,
        y = py - playerHeight / 2,
        width = playerWidth,
        height = playerHeight
    }


    if love.keyboard.isDown("e") and mathPlus.aabbCollision(
            playerRect.x, playerRect.y, playerRect.width, playerRect.height,
            bx, by, bw, bh
        ) then
        if not entity.components.state.pressed then
            entity.components.state.pressed = true
            local action = entity.components.state.action
            if action then
                action()
            end
        end
    else
        entity.components.state.pressed = false
    end
end, "update")





return button
