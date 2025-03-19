local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local player = require('engine.player')
local graphics = require('engine.graphics')
local ecs = require('engine.ecs')
local game_scene = {}
local startTime = 0

ecs.createComponent("position", { x = 0, y = 0 })
ecs.createComponent("sprite", { image = love.graphics.newImage("assets/block.png"), width = 32, height = 32 })
ecs.createEntity("wall", { "position", "sprite" })
ecs.addComponent(ecs.entities[1], "position", { x = 100, y = 100 })
ecs.addComponent(ecs.entities[1], "sprite",
    { image = love.graphics.newImage("assets/block.png"), width = 32, height = 32 })
ecs.createSystem("render", { "position", "sprite" }, function(entity)
    if (entity.type == "wall") then
        -- draw wall cubes on all left and right sides of the screen
        for i = 0, graphics.getScreenWidth() / 16 do
            love.graphics.draw(entity.components.sprite.image, i * 16, 0, 0, 1, 1)
            love.graphics.draw(entity.components.sprite.image, i * 16, graphics.getScreenHeight() - 16, 0, 1, 1)
        end

        -- draw wall cubes on all bottom and top sides of the screen
        for i = 0, graphics.getScreenHeight() / 16 do
            love.graphics.draw(entity.components.sprite.image, 0, i * 16, 0, 1, 1)
            love.graphics.draw(entity.components.sprite.image, graphics.getScreenWidth() - 16, i * 16, 0, 1, 1)
        end
    end

    if (entity.type == "player") then
        love.graphics.draw(entity.components.sprite.image, entity.components.position.x, entity.components.position.y, 0,
            1, 1)
    end
end)


-- Player
ecs.createEntity("player", { "position", "sprite" })
ecs.addComponent(ecs.entities[2], "position", { x = 100, y = 100 })
ecs.addComponent(ecs.entities[2], "sprite",
    { image = love.graphics.newImage("assets/block.png"), width = 32, height = 32 })

ecs.createSystem("controllable", { "position" }, function(entity)
    if (entity.type == "player") then
        local dt = love.timer.getDelta()

        -- Horizontal movement
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            if entity.components.position.x > 16 then
                entity.components.position.x = entity.components.position.x - 100 * dt
            else
                entity.components.position.x = 16
            end
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            if entity.components.position.x < graphics.getScreenWidth() - 16 - 32 then
                entity.components.position.x = entity.components.position.x + 100 * dt
            else
                entity.components.position.x = graphics.getScreenWidth() - 16 - 32
            end
        end

        -- Jump logic
        if not entity.isJumping then
            if love.keyboard.isDown("space") then
                entity.isJumping = true
                entity.velocityY = -300 -- Initial jump velocity
            end
        end

        -- Apply gravity if jumping
        if entity.isJumping then
            entity.velocityY = (entity.velocityY or 0) + 500 * dt -- Gravity strength
            entity.components.position.y = entity.components.position.y + entity.velocityY * dt

            -- Check if the player has landed
            if entity.components.position.y >= graphics.getScreenHeight() - 32 then
                entity.components.position.y = graphics.getScreenHeight() - 32 -- Snap to the ground
                entity.isJumping = false
                entity.velocityY = 0                                           -- Reset velocity
                if entity.fallSound then
                    entity.fallSound:stop()                                    -- Stop any currently playing sound
                    entity.fallSound:play()
                end
            end
        end

        -- Sprint logic
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            entity.speed = 300
        else
            entity.speed = 100
        end
    end
end)


function game_scene.load()
    player.load()
    startTime = love.timer.getTime()
    print("Game scene loaded")
end

function game_scene.update(dt)
    -- Add main menu-specific update code here

    ecs.updateSystemsForAllEntities()

    -- Update the position of the wall entity
    ecs.update(dt)
end

function game_scene.draw()
    love.graphics.clear(colors.hexToRgb("#FBEED5"))
    love.graphics.setColor(colors.text)
    -- Calculate elapsed time
    local elapsedTime = love.timer.getTime() - startTime
    local seconds = math.floor(elapsedTime)
    local milliseconds = math.floor((elapsedTime - seconds) * 1000)

    -- Display the timer as seconds:milliseconds
    render.print(string.format("%02d:%03d", seconds, milliseconds), 70, 40, 32, colors.hexToRgb("#221D1E"),
        "assets/DepartureMono-Regular.otf")
    ui.button({ name = "Back", action = "back" }, 70, 80, colors.hexToRgb("#FCD6A6"), function()
        startTime = 0
        elapsedTime = 0
        state.switch("main_menu")
    end)


    ecs.draw()
end

return game_scene
