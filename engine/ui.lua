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
    font = love.graphics.newFont("assets/DepartureMono-Regular.otf", font_size)
    if not font_color then
        font_color = colors.text
    end

    if not bg_color then
        bg_color = colors.base
    end

    if not hover_color then
        hover_color = colors.overlay1
    end

    love.graphics.setFont(font)


    -- Calculate the width of the text
    local text_width = font:getWidth(text)
    -- Set the button width based on the text width plus padding
    width = text_width + 40

    -- Change the background color if the mouse is over the button
    if isMouseOver(x, y, width, height) then
        love.graphics.setColor(hover_color)
        if (love.mouse.isDown(1)) then
            love.graphics.setColor(colors.overlay2)
        end
    else
        love.graphics.setColor(bg_color)
    end
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.rectangle("fill", x, y, width, height + 8, 10, 10, 30)

    love.graphics.setColor(font_color)

    -- Calculate the position to center the text
    local text_x = x + (width - text_width) / 2
    local text_y = y + (height - font:getHeight() + 8) / 2

    love.graphics.print(text, text_x, text_y)
end

local dropdowns = {}

function ui.dropdown(id, text, x, y, width, height, options, font_size, font_color, bg_color, hover_color, option_height)
    if not dropdowns[id] then
        dropdowns[id] = { open = false, selected = nil, x = x, y = y, width = width, height = height }
    end

    local dropdown = dropdowns[id]

    -- Draw the dropdown button
    ui.button(text, x, y, width + 1.4 + string.len(text), height, font_size, font_color, bg_color, hover_color)

    -- Toggle dropdown open/close on click
    if dropdown.clicked then
        dropdown.open = not dropdown.open
        dropdown.clicked = false
    end

    -- Draw the options if the dropdown is open
    if dropdown.open then
        for i, option in ipairs(options) do
            local option_y = y + height + font_size + 50 * (i - 1)
            ui.dropdownOption(option, x, option_y, width, option_height, font_size, font_color, bg_color, hover_color, function()
                dropdown.selected = option
                dropdown.open = false
            end)
        end
    end
end

function ui.dropdownOption(text, x, y, width, height, font_size, font_color, bg_color, hover_color, onClick)
    -- Draw the option
    ui.button(text, x, y, width + 1.4 + string.len(text), height, font_size, font_color, bg_color, hover_color)

    -- Handle option click
    if isMouseOver(x, y, width, height) and love.mouse.isDown(1) then
        onClick()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for id, dropdown in pairs(dropdowns) do
            if isMouseOver(dropdown.x, dropdown.y, dropdown.width + 100, dropdown.height) then
                dropdown.clicked = true
            end
        end
    end
end

return ui