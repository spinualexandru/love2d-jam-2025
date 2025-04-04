local colors = require('engine.colors')
local ui_interfaces = require('ui.entry')
local graphics = require('engine.graphics')
local events = require('events')
local settings = require('engine.settings')


local ui = {
    current_interface = nil,
    current_item = nil
}

local function isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end

function ui.load()
    ui.current_interface = ui_interfaces.interfaces.main_menu
    ui.current_item = ui.current_interface.default_item
end

function ui.button(item, x, y, color, action)
    local width = string.len(item.name) * 24
    local text_size = 24
    local height = text_size + 10
    local text = item.name
    local oldScreenColor = { love.graphics.getColor() }
    local textColor = colors.hexToRgb("#0f380f")

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", text_size))
    if isMouseOver(x, y, width + string.len(item.name) * 10, height) then
        color = colors.hexToRgb("#8baa0a")
        textColor = colors.hexToRgb("#000000")
        if love.mouse.isDown(1) then
            action()
        end
    end
    love.graphics.setColor(color)


    love.graphics.rectangle("fill", x, y + 12, width + string.len(item.name) * 14, text_size - 5, 0)
    love.graphics.rectangle("fill", x, y + 22, width + string.len(item.name) * 10, text_size - 0, 0)
    love.graphics.rectangle("fill", x, y + 6, width + string.len(item.name) * 12, text_size - 5, 0)
    love.graphics.setColor(textColor)
    love.graphics.print(text, x + 10, y + 10)
    love.graphics.setColor(oldScreenColor)
end

function ui.checkbox(item, x, y, color, action)
    local width = string.len(item.name) * 24
    local text_size = 24
    local height = text_size + 10
    local isChecked = item.checked
    local text = item.name
    local textColor = colors.text

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", text_size))
    if isMouseOver(x, y, width + string.len(item.name) * 10, height) then
        color = colors.hexToRgb("#FCD6A6")
        textColor = colors.hexToRgb("#0D0D0D")
        if love.mouse.isDown(1) and not ui.mouse_pressed then
            ui.mouse_pressed = true
            item.checked = not item.checked
            action()
        elseif not love.mouse.isDown(1) then
            ui.mouse_pressed = false
        end
    end

    love.graphics.setColor(textColor)

    love.graphics.rectangle("line", x, y + 4, 42, 42, 0)

    if isChecked then
        love.graphics.setColor(colors.hexToRgb("#0D0D0D"))
        love.graphics.rectangle("fill", x + 6.5, y + 9.5, 30, 30, 0)
    end

    local buttonSpacing = 50
    love.graphics.rectangle("fill", x + buttonSpacing, y + 12, width + string.len(item.name) * 14, text_size - 5, 0)
    love.graphics.rectangle("fill", x + buttonSpacing, y + 22, width + string.len(item.name) * 10, text_size - 0, 0)
    love.graphics.rectangle("fill", x + buttonSpacing, y + 6, width + string.len(item.name) * 12, text_size - 5, 0)
    love.graphics.setColor(color)
    love.graphics.print(text, x + buttonSpacing + 10, y + 10)

    if isChecked then
        love.graphics.setColor(colors.hexToRgb("#0D0D0D"))
        love.graphics.rectangle("fill", x + 10, y + 10, 10, 10, 0)
    end
end

function ui.slider(item, x, y, color, action, min, max, value)

end

function ui.dropdown(item, x, y, color, action, options)

end

function ui.textbox(item, x, y, prompt, placeholder, color, action)
    local width = string.len(item.name) * 24
    local text_size = 24
    local height = text_size + 10
    local text = settings[item.variable]
    local textColor = colors.text

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", text_size))
    if isMouseOver(x, y, width + string.len(item.name) * 10, height) then
        color = colors.hexToRgb("#FCD6A6")
        textColor = colors.hexToRgb("#FFFFFF")
        if love.mouse.isDown(1) then
            action()
        end
    end

    love.graphics.setColor(textColor)




    love.graphics.rectangle("fill", x, y + 12, width + string.len(item.name) * 14, text_size - 5, 0)
    love.graphics.rectangle("fill", x, y + 22, width + string.len(item.name) * 10, text_size - 0, 0)
    love.graphics.rectangle("fill", x, y + 6, width + string.len(item.name) * 12, text_size - 5, 0)
    love.graphics.setColor(colors.hexToRgb("#FFA07A"))


    if (love.timer.getTime() % 1) > 0.5 then
        love.graphics.rectangle("fill", x + string.len(text) * 18, y + 10, 5, 30, 0)
    end
    love.graphics.setColor(color)
    love.graphics.print(text, x + 10, y + 10)
end

function ui.progressBar(item, x, y, width, color, action, min, max, value)
    local height = 30
    love.graphics.setColor(colors.hexToRgb("#FFFFFF"))

    love.graphics.rectangle("fill", x, y, width, height, 0)
    love.graphics.setColor(colors.hexToRgb("#FFFFFF"))
    love.graphics.rectangle("fill", x, y, width * (value / max), height, 0)
    love.graphics.setColor(colors.hexToRgb("#000000"))
    love.graphics.rectangle("line", x, y, width, height, 0)
    love.graphics.setColor(colors.hexToRgb("#000000"))
end

function ui.draw()
    local interface = ui.current_interface or ui_interfaces.interfaces.main_menu

    for i, item in ipairs(interface.items) do
        if item.type == "button" then
            ui.button(item, 10, (graphics.getScreenHeight() / 7) + i * 55, colors.hexToRgb("#FCD6A6"), function()
                if (item.opens) then
                    if ui_interfaces.interfaces[item.opens] then
                        ui.current_interface = ui_interfaces.interfaces[item.opens]
                        ui.current_item = ui.current_interface.default_item
                    end
                end

                if (item.action) then
                    events.emit(item.action)
                end
            end)
        end

        if item.type == "checkbox" then
            ui.checkbox(item, 10, (graphics.getScreenHeight() / 7) + i * 55, colors.hexToRgb("#FCD6A6"), function()
                if (item.opens) then
                    ui.current_interface = ui_interfaces.interfaces[item.opens]
                    ui.current_item = ui.current_interface.default_item
                end

                if (item.action) then
                    events.emit(item.action)
                end
            end)
        end

        if item.type == "progressBar" then
            ui.progressBar(item, 10, (graphics.getScreenHeight() / 7) + i * 55, colors.hexToRgb("#FCD6A6"), function()
                if (item.opens) then
                    ui.current_interface = ui_interfaces.interfaces[item.opens]
                    ui.current_item = ui.current_interface.default_item
                end

                if (item.action) then
                    events.emit(item.action)
                end
            end, item.min, item.max, item.value)
        end

        if item.type == "textbox" then
            ui.textbox(item, 10, (graphics.getScreenHeight() / 7) + i * 55, "Prompt", "Placeholder",
                colors.hexToRgb("#FCD6A6"), function()
                    if (item.opens) then
                        ui.current_interface = ui_interfaces.interfaces[item.opens]
                        ui.current_item = ui.current_interface.default_item
                    end

                    if (item.action) then
                        events.emit(item.action)
                    end
                end)
        end
    end
end

return ui
