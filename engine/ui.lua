local colors = require('engine.colors')

local ui = {}

local function isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end

function ui.button(text, x, y, width, height, font_size, font_color, bg_color, hover_color)
    if not font_size then
        font_size = 12
    end

    if not font_color then
        font_color = colors.text
    end

    if not bg_color then
        bg_color = colors.base
    end

    if not hover_color then
        hover_color = colors.overlay1
    end

    -- Change the background color if the mouse is over the button
    if isMouseOver(x, y, width, height) then
        love.graphics.setColor(hover_color)
    else
        love.graphics.setColor(bg_color)
    end

    love.graphics.rectangle("fill", x, y, width + 18, height, 10, 10, 25)

    love.graphics.setColor(font_color)
    love.graphics.setFont(love.graphics.newFont(font_size))
    love.graphics.print(text, x + font_size / 1.2, y + font_size / 1.8)
end

return ui