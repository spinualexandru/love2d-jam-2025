local state      = require('engine.state')
local ui         = require('engine.ui')
local render     = require('engine.render')
local colors     = require('engine.colors')
local graphics   = require('engine.graphics')
local physics    = require('game.physics')
local player     = require('game.player')
local walls      = require('game.walls')
local settings   = require('engine.settings')
local button     = require('game.button')
local ecs        = require('engine.ecs')
local hud        = require('engine.hud')

local game_scene = {}
local startTime  = 0
local bulbImage
local buttonsGap = 200

function game_scene.load()
    -- Clear the terminal
    ecs.clear()

    io.write("\27[2J\27[H")
    bulbImage = love.graphics.newImage("assets/bulb.png")
    -- Load physics, walls, and player
    physics.load()
    walls.load()
    player.load()

    -- Load the button image
    button.load()

    -- Create three buttons at different positions
    local bottomLocation = love.graphics.getHeight() - 100
    local middleLocation = love.graphics.getWidth() / 2
    button.create(middleLocation - buttonsGap, bottomLocation, 50, 50)
    button.create(middleLocation, bottomLocation, 50, 50)
    button.create(middleLocation + buttonsGap, bottomLocation, 50, 50)


    -- Create a health bar
    hud.createBar("health", 60, 60, 400, 35, { 0, 1, 0 }, 100) -- Green bar for stamina


    hud.createBar("stamina", 60, 110, 400, 35, { 0, 1, 0 }, 100) -- Green bar for stamina

    -- Create a stamina bar
    -- Initialize start time
    startTime = love.timer.getTime()
end

function game_scene.unload()
    -- Clear walls when unloading the scene
    walls.clear()
end

function game_scene.update(dt)
    -- Update physics world
    physics.update(dt)

    -- Update player
    player.update(dt)
    ecs.update(dt)
    local stamina = math.max(0, hud.getBarValue("stamina") - dt * 10)
    hud.updateBar("stamina", stamina)
    -- Example: Decrease stamina over time
    local stamina = math.max(0, hud.getBarValue("stamina") - dt * 10)
    hud.updateBar("stamina", stamina)
end

function game_scene.draw()
    love.graphics.clear(colors.hexToRgb("#0f380f"))
    love.graphics.setColor(colors.hexToRgb("#9bbc0f"))

    -- Calculate elapsed time
    local elapsedTime = love.timer.getTime() - startTime
    local seconds = math.floor(elapsedTime)
    local milliseconds = math.floor((elapsedTime - seconds) * 1000)


    -- Display the timer as seconds:milliseconds
    render.print(string.format("%02d:%03d", seconds, milliseconds), 60, 150, 32, colors.hexToRgb("#9bbc0f"),
        "assets/DepartureMono-Regular.otf")
    ui.button({ name = "End", action = "back" }, love.graphics.getWidth() - 170, 55, colors.hexToRgb("#9bbc0f"),
        function()
            startTime = 0
            elapsedTime = 0
            state.switch("main_menu")
        end)

    ecs.draw()
    -- Draw player
    player.draw()
    -- Draw walls
    walls.draw()

    if bulbImage then
        local bulbX = (love.graphics.getWidth() - bulbImage:getWidth()) / 4 -- Center horizontally
        local bulbY = 16 * 3                                                -- Position near the top

        love.graphics.draw(bulbImage, bulbX * 2, bulbY, 0, 4, 4)
    end
end

local resizing = false -- Flag to track if resizing is triggered by setMode

function love.resize(w, h)
    if not physics.world then
        return
    end
    walls.clear()
    walls.load()
    game_scene.load()
end

return game_scene
