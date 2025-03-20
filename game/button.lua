local ecs = require('engine.ecs')
local debug = require('libs.debug')
local mathPlus = require('engine.math')
local hud = require('engine.hud')
local player = require('game.player') -- Import the player module
local button = {}
local buttonImage                     -- Declare the button image variable

-- Load the button image
function button.load()
    buttonImage = love.graphics.newImage("assets/button-round.png")
    print("Button image loaded:", buttonImage)
end

function button.create(x, y, width, height)
    -- If there is no width or height, read the image size
    if not width or not height then
        if buttonImage then
            width = buttonImage:getWidth()
            height = buttonImage:getHeight()
        else
            error("Button image not loaded. Call button.load() before creating a button.")
        end
    end

    -- Create the button entity
    local entity = ecs.createEntity("button", {
        position = { x = x, y = y },
        size = { width = width, height = height },
        state = {
            pressed = false,
            action = function()
                ecs.removeAllEntitiesOfType("announcement") -- Remove all previous announcements
                -- print random number

                print("Button pressed at:", math.random(1, 100))
                hud.announcement("Button  pressed now " .. math.random(1, 100))
                hud.achievement("Clicked a button")
            end
        },

    })


    -- Debug print to confirm the position
end

ecs.createSystem("buttonRender", { "position", "size", "state" }, function(entity)
    -- Check if the entity is a button
    if entity.type ~= "button" then return end    -- Skip if not a button
    local oldColor = { love.graphics.getColor() } -- Save the old color
    love.graphics.setColor(1, 1, 1)               -- Set color to white
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height


    if buttonImage then
        -- Draw the button image
        love.graphics.draw(buttonImage, x, y, 0, 1, 1)
    else
        -- Fallback: Draw a rectangle if the image is not loaded
        love.graphics.setColor(1, 0, 0) -- Red color
        love.graphics.rectangle("fill", x, y, width, height)
    end

    love.graphics.setColor(oldColor)
end, "render")


ecs.createSystem("buttonInteraction", { "position", "size", "state" }, function(dt, entity)
    -- Check if the entity is a button
    if entity.type ~= "button" then return end -- Skip if not a button

    local px, py = player.getPosition()        -- Get the player's position
    local bx, by = entity.components.position.x, entity.components.position.y
    local bw, bh = entity.components.size.width, entity.components.size.height

    local playerWidth, playerHeight = 32, 50 -- Replace with actual player dimensions
    local playerRect = {
        x = px - playerWidth / 2,            -- Adjust x to the top-left corner
        y = py - playerHeight / 2,           -- Adjust y to the top-left corner
        width = playerWidth,
        height = playerHeight
    }

    -- Check if the player is pressing E and is in the button area
    if love.keyboard.isDown("e") and mathPlus.aabbCollision(
            playerRect.x, playerRect.y, playerRect.width, playerRect.height,
            bx, by, bw, bh
        ) then
        -- Call the button action
        if not entity.components.state.pressed then
            entity.components.state.pressed = true

            print("Button" .. entity.id .. " pressed")
            local action = entity.components.state.action
            if action then
                action()
            end
        end
    else
        entity.components.state.pressed = false
    end
end, "update")

-- Button click detection



return button
