local render = {}
local colors = require('engine.colors')

function render.print(text, x, y, font_size, font_color)
    if not font_size then
        font_size = 12
    end

    if not font_color then
        font_color = colors.text
    end

    love.graphics.setColor(font_color)
    love.graphics.setFont(love.graphics.newFont(font_size))
    love.graphics.print(text, x, y)
end

return render