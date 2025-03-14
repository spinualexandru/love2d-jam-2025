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
    settings.loadSettings()
end

function love.update(dt)
    hotreload.update(dt)
end

function love.draw()
    love.graphics.clear(colors.base)
    hotreload.draw()
    love.graphics.setColor(colors.text)
    love.graphics.setFont(love.graphics.newFont(20))
    render.print("Hello, World!", 10, 10, 20, colors.text)

    ui.button("Click me", 10, 50, 100, 50, 20, colors.mantle, colors.red, colors.flamingo)
end
