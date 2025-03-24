local state = require('engine.state')
local ui = require('engine.ui')
local render = require('engine.render')
local colors = require('engine.colors')
local game_over_scene = {}

function game_over_scene.load()
end

function game_over_scene.draw()
    love.graphics.clear(colors.hexToRgb("#0f380f"))
    love.graphics.setColor(colors.hexToRgb("#9bbc0f"))
    render.print("Game over", love.graphics.getWidth() / 2 - 300,
        love.graphics.getHeight() / 2 - 120
        , 72,
        colors.hexToRgb("#9bbc0f"), "assets/DepartureMono-Regular.otf")
    render.print("The slime stopped providing energy\nfor the universe and everyone died\nin horrible pain",
        love.graphics.getWidth() / 2 - 300,
        love.graphics.getHeight() / 2 - 30
        , 26,
        colors.hexToRgb("#9bbc0f"), "assets/DepartureMono-Regular.otf")
    ui.button({ name = "Back to main menu", action = "back" }, love.graphics.getWidth() / 2 - 300,
        love.graphics.getHeight() / 2 + 70, colors.hexToRgb("#9bbc0f"),
        function()
            state.switch("main_menu")
        end)
end

function game_over_scene.update(dt)

end

return game_over_scene
