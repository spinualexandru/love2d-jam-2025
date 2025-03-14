local src_path = "?.lua"
package.path = src_path .. ";" .. package.path

local hotreload = require("engine.hotreload")
local graphics = require('engine.graphics')
local settings = require('engine.settings')
local colors = require('engine.colors')
local render = require('engine.render')
local ui = require('engine.ui')


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    hotreload.load()
    font = love.graphics.newFont("assets/DepartureMono-Regular.otf", 42)
    settings.loadSettings()
end

function love.update(dt)
    hotreload.update(dt)
end

function love.draw()
    --{ 0.1647, 0.2431, 0.2392 }
    love.graphics.clear(colors.hexToRgb("#FBEED5"))

    love.graphics.setColor(colors.text)
    render.print("The Stock Market Strategist", 10, 10, 32, colors.hexToRgb("#221D1E"),
        "assets/DepartureMono-Regular.otf")

    ui.drawInterface("main_menu")

    hotreload.draw()
end
