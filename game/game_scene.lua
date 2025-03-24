local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local graphics = require('engine.graphics')
local physics = require('game.physics')

local walls = require('game.walls')

local settings = require('engine.settings')
local button = require('game.button')

local ecs = require('engine.ecs')
local hud = require('engine.hud')
local player = require('game.player')
local run = require('game.run')
local portal = require('game.portal')
local game_scene = {
    isPaused = false
}
local startTime = 0
local buttonsGap = 200

function game_scene.load()
    ecs.clear()

    io.write("\27[2J\27[H")

    physics.load()
    walls.load()

    button.load()
    portal.load()
    run.load()


    local bottomLocation = love.graphics.getHeight() - 100
    local middleLocation = love.graphics.getWidth() / 2
    button.create(middleLocation - buttonsGap, bottomLocation, 50, 50)
    button.create(middleLocation, bottomLocation, 50, 50)
    button.create(middleLocation + buttonsGap, bottomLocation, 50, 50)
    player.load()


    hud.createBar("health", 60, 60, 350, 35, { 0, 1, 0 }, 100)
    hud.createBar("stamina", 60, 110, 350, 35, { 0, 1, 0 }, 100)




    startTime = love.timer.getTime()
end

function game_scene.unload()
    walls.clear()
end

function game_scene.update(dt)
    if run.getIsPaused() then
        return
    end

    physics.update(dt)


    ecs.update(dt)
    hud.updateBar("health", player.getHealth())
    hud.updateBar("stamina", player.getStamina())
    if (player.getHealth() == 90) then
        state.switch("game_over")
    end
end

function game_scene.draw()
    if run.getIsPaused() then
        return
    end
    love.graphics.clear(colors.hexToRgb("#0f380f"))
    love.graphics.setColor(colors.hexToRgb("#9bbc0f"))



    render.print(run.getFormattedTime(), 60, 185, 26, colors.hexToRgb("#9bbc0f"),
        "assets/DepartureMono-Regular.otf")
    ui.button({ name = "End", action = "back" }, love.graphics.getWidth() - 170, 55, colors.hexToRgb("#9bbc0f"),
        function()
            startTime = 0
            elapsedTime = 0
            state.switch("main_menu")
        end)

    ecs.draw()

    walls.draw()
end

local resizing = false

function love.resize(w, h)
    if not physics.world then
        return
    end
    walls.clear()
    walls.load()
    game_scene.load()
end

return game_scene
