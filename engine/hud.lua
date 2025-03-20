local ecs = require('engine.ecs')
local colors = require('engine.colors')
local hud = {}

-- Function to create a new bar entity
function hud.createBar(name, x, y, width, height, color, maxValue)
    ecs.createEntity("hud_bar", {
        name = name,
        position = { x = x, y = y },
        size = { width = width, height = height },
        color = color or { 0, 1, 0 }, -- Default to green
        value = maxValue,
        maxValue = maxValue
    })
end

-- Function to update a bar's value
function hud.updateBar(name, value)
    local entities = ecs.getEntitiesByComponent("name")
    for _, entity in ipairs(entities) do
        if entity.components.name == name then
            entity.components.value = math.max(0, math.min(value, entity.components.maxValue)) -- Clamp value
        end
    end
end

-- Function to get a bar's value
function hud.getBarValue(name)
    local entities = ecs.getEntitiesByComponent("name")
    for _, entity in ipairs(entities) do
        if entity.components.name == name then
            return entity.components.value
        end
    end
    return 0 -- Default to 0 if the bar does not exist
end

-- ECS system to render HUD bars
ecs.createSystem("hudRender", { "position", "size", "color", "value", "maxValue" }, function(entity)
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    local color = entity.components.color
    local value = entity.components.value
    local maxValue = entity.components.maxValue


    -- Draw the border
    love.graphics.setColor(colors.greens.shadow)
    love.graphics.rectangle("fill", x, y, width, height)

    -- Draw the filled portion of the bar
    love.graphics.setColor(colors.greens.highlight2)
    local filledWidth = (value / maxValue) * width
    love.graphics.rectangle("fill", x, y + 5, filledWidth, height - 10)

    -- Draw the bar value text
    love.graphics.setColor(1, 1, 1) -- White color for text
    love.graphics.printf(tostring(math.floor(value)), x, y + (height / 2) - 16, width, "center")
end, "render")

return hud
