local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local main_menu_scene = {}

function main_menu_scene.load()
end

function main_menu_scene.draw()
    love.graphics.clear(colors.hexToRgb("#0f380f"))
    love.graphics.setColor(colors.hexToRgb("#9bbc0f"))
    render.print("Exit Strategy", 10, 10, 32, colors.hexToRgb("#9bbc0f"), "assets/DepartureMono-Regular.otf")

    render.print(
        "I registered on the jam before\nknowing my daughterwould be born\nearlier but I still wanted\nto have something submitted\nfor my first game ever as well as jam.\nEverything was made from scratch:\n-Sound\n-No base code to start from\n-Graphics\nHope you enjoy! \n\nWith LÖVE, Zyth",
        love.graphics.getWidth() - 420, 20, 18,
        colors.hexToRgb("#9bbc0f"), "assets/DepartureMono-Regular.otf")
    ui.draw()
end

function main_menu_scene.update(dt)

end

return main_menu_scene
