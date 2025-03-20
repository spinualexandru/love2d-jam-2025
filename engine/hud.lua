local ecs = require('engine.ecs')
local colors = require('engine.colors')
local hud = {}


-- Function to create a new bar entity
function hud.createBar(name, x, y, width, height, color, maxValue)
    ecs.createEntity("hud_bar", {
        type = "hud_bar", -- Add type as a component
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

function hud.announcement(text, x, y)
    if not x or not y then
        x = love.graphics.getWidth() / 2
        y = love.graphics.getHeight() / 2
    end

    -- Create a new entity for the announcement
    ecs.createEntity("announcement", {
        type = "announcement", -- Add type as a component
        position = { x = x - string.len(text) * 10, y = y },
        size = { width = 200, height = 50 },
        text = text,
        color = { 1, 1, 1, 1 }, -- White color with full opacity
        timer = 3               -- Duration in seconds
    })
end

function hud.achievement(text)
    ecs.removeAllEntitiesOfType("achievement") -- Remove all previous achievements
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Create an entity for the achievement notification
    ecs.createEntity("achievement", {
        type = "achievement",                                         -- Add type as a component
        position = { x = screenWidth - 310, y = screenHeight - 164 }, -- Bottom right of the screen
        size = { width = 64, height = 28 },
        text = text,
        image = love.graphics.newImage("assets/achievement.png"),
        color = { 1, 1, 1, 1 }, -- White color with full opacity
        timer = 3               -- Duration in seconds
    })
end

-- ECS system to update the announcement timer
-- ECS system to update the announcement timer
ecs.createSystem("announcementUpdate", { "timer", "color" }, function(dt, entity)
    -- Decrease the timer
    entity.components.timer = entity.components.timer - dt

    -- Gradually reduce the alpha value of the color
    local color = entity.components.color
    if entity.components.timer > 0 then
        color[4] = math.max(0, entity.components.timer / 3) -- Fade out over 3 seconds
    else
        -- Remove the entity when the timer reaches zero
        ecs.removeEntity(entity)
    end
end, "update")


ecs.createSystem("achievementUpdate", { "timer", "color" }, function(dt, entity)
    -- Decrease the timer
    entity.components.timer = entity.components.timer - dt

    -- Gradually reduce the alpha value of the color
    local color = entity.components.color
    if entity.components.timer > 0 then
        color[4] = math.max(0, entity.components.timer / 3) -- Fade out over 3 seconds
    else
        -- Remove the entity when the timer reaches zero
        ecs.removeEntity(entity)
    end
end, "update")
-- ECS system to render the announcement

ecs.createSystem("announcementRender", { "position", "size", "text", "color", "type" }, function(entity)
    if entity.components.type ~= "announcement" then return end -- Skip if not an announcement

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 24))
    -- Save the current color

    -- Get the entity's components
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    local text = entity.components.text
    local color = entity.components.color

    -- Set the color with alpha for the announcement text
    love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
    love.graphics.print(text, x, y, 0, 1, 1)
end, "render")

ecs.createSystem("achievementRender", { "position", "size", "text", "image", "color", "type" }, function(entity)
    if entity.components.type ~= "achievement" then return end -- Skip if not an achievement
    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 16))

    local position = entity.components.position
    local size = entity.components.size
    local text = entity.components.text
    local image = entity.components.image
    local color = entity.components.color

    -- Draw the achievement background image
    love.graphics.setColor(color[1], color[2], color[3], color[4]) -- Apply fading alpha
    love.graphics.draw(image, position.x, position.y, 0, 4, 4)

    -- Draw the text in the middle of the achievement
    love.graphics.setColor(colors.greens.border[1], colors.greens.border[2], colors.greens.border[3],
        color[4]) -- Black text with fading alpha
    love.graphics.print("Achievement unlocked", position.x + 20, position.y + size.height / 2)
    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 16))

    love.graphics.print(text, position.x + 20, position.y + size.height / 2 + 25)
end, "render")

-- ECS system to render HUD bars
ecs.createSystem("progressBarRender", { "position", "size", "color", "value", "maxValue" }, function(entity)
    if entity.components.type ~= "hud_bar" then return end -- Skip if not an achievement


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
