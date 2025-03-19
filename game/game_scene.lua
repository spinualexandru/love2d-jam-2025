local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local player = require('engine.player')
local game_scene = {}
local startTime = 0

function game_scene.load()
    player.load()
    startTime = love.timer.getTime()
    print("Game scene loaded")
end

function game_scene.update(dt)
    -- Add main menu-specific update code here
    player.update(dt)
end

function game_scene.draw()
    love.graphics.clear(colors.hexToRgb("#FBEED5"))
    love.graphics.setColor(colors.text)
    -- Calculate elapsed time
    local elapsedTime = love.timer.getTime() - startTime
    local seconds = math.floor(elapsedTime)
    local milliseconds = math.floor((elapsedTime - seconds) * 1000)

    -- Display the timer as seconds:milliseconds
    render.print(string.format("%02d:%03d", seconds, milliseconds), 10, 10, 32, colors.hexToRgb("#221D1E"),
        "assets/DepartureMono-Regular.otf")
    ui.button({ name = "Back", action = "back" }, 10, 50, colors.hexToRgb("#FCD6A6"), function()
        startTime = 0
        elapsedTime = 0
        state.switch("main_menu")
    end)
    player.draw()
end

return game_scene
