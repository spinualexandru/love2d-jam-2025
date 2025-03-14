local src_path = "?.lua"
package.path = src_path .. ";" .. package.path

local hotreload = require("engine.hotreload")
local graphics = require('engine.graphics')
local settings = require('engine.settings')
local colors = require('engine.colors')
local render = require('engine.render')
local ui = require('engine.ui')

function love.load()
    hotreload.load()
    font = love.graphics.newFont("assets/DepartureMono-Regular.otf", 42)
    settings.loadSettings()
end

function love.update(dt)
    hotreload.update(dt)
end

function love.draw()
    love.graphics.clear({ 0.1647, 0.2431, 0.2392 })
    hotreload.draw()
    love.graphics.setColor(colors.text)
    render.print("The Stock Market Strategist", 10, 10, 42, colors.hexToRgb("#FCD6A6"), font)
    local options = { "Option 1", "Option 2", "Option 3" }
    ui.dropdown("dropdown1", "Select an option", 10, 120, 150, 30, options, 16, { 1, 1, 1 }, colors.blue, colors.lavender, 30)
    ui.button("Click me", 10, 50, 100, 38, 42, colors.mantle, colors.blue, colors.lavender)
end
