local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local main_menu_scene = {}

function main_menu_scene.load()
end

function main_menu_scene.draw()
    love.graphics.clear(colors.hexToRgb("#FBEED5"))
    love.graphics.setColor(colors.text)
    render.print("Main Menu", 10, 10, 32, colors.hexToRgb("#221D1E"), "assets/DepartureMono-Regular.otf")
    ui.draw()
end

function main_menu_scene.update(dt)
    -- Add main menu-specific update code here
end

return main_menu_scene
