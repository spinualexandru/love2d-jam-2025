local colors = require('engine.colors')
local ui_interfaces = require('ui.entry')
local graphics = require('engine.graphics')

local ui = {}

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
    local textColor = colors.text

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", text_size))
    if isMouseOver(x, y, width + string.len(item.name) * 10, height) then
        color = colors.hexToRgb("#FCD6A6")
        textColor = colors.hexToRgb("#0D0D0D")
        if love.mouse.isDown(1) then
            action()
        end
    end

    love.graphics.setColor(textColor)
    love.graphics.rectangle("fill", x, y + 12, width + string.len(item.name) * 14, text_size - 5, 0)
    love.graphics.rectangle("fill", x, y + 22, width + string.len(item.name) * 10, text_size - 0, 0)
    love.graphics.rectangle("fill", x, y + 6, width + string.len(item.name) * 12, text_size - 5, 0)
    love.graphics.setColor(color)
    love.graphics.print(text, x + 10, y + 10)
end

function ui.drawInterface(name)
    local interface = ui_interfaces.interfaces[name]
    for i, item in ipairs(interface.items) do
        if item.type == "button" then
            ui.button(item, 10, (graphics.getScreenHeight() / 7) + i * 55, colors.hexToRgb("#FCD6A6"), function()
                print("Start")
            end)
        end
    end
end

return ui
