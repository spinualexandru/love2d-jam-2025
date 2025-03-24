local ecs = require('engine.ecs')
local colors = require('engine.colors')
local hud = {}



function hud.createBar(name, x, y, width, height, color, maxValue)
    ecs.createEntity("hud_bar", {
        type = "hud_bar",
        name = name,
        position = { x = x, y = y },
        size = { width = width, height = height },
        color = color or { 0, 1, 0 },
        value = maxValue,
        maxValue = maxValue
    })
end

function hud.updateBar(name, value)
    local entities = ecs.getEntitiesByType("hud_bar")
    for _, entity in ipairs(entities) do
        if entity.components.name == name then
            entity.components.value = value
            return
        end
    end
end

function hud.getBarValue(name)
    local entities = ecs.getEntitiesByType("hud_bar")
    for _, entity in ipairs(entities) do
        if entity.components.name == name then
            return entity.components.value
        end
    end
    return 0
end

function hud.announcement(text, x, y)
    ecs.removeAllEntitiesOfType("announcement")
    if not x or not y then
        x = love.graphics.getWidth() / 2
        y = love.graphics.getHeight() / 2
    end


    ecs.createEntity("announcement", {
        type = "announcement",
        position = { x = x - string.len(text) * 10, y = y },
        size = { width = 200, height = 50 },
        text = text,
        color = { 1, 1, 1, 1 },
        timer = 3
    })
end

function hud.achievement(text)
    ecs.removeAllEntitiesOfType("achievement")
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()


    ecs.createEntity("achievement", {
        type = "achievement",
        position = { x = screenWidth - 310, y = screenHeight - 164 },
        size = { width = 64, height = 28 },
        text = text,
        image = love.graphics.newImage("assets/achievement.png"),
        color = { 1, 1, 1, 1 },
        timer = 3
    })
end

ecs.createSystem("announcementUpdate", { "timer", "color" }, function(dt, entity)
    if entity.components.type ~= "announcement" then return end

    entity.components.timer = entity.components.timer - dt


    local color = entity.components.color
    if entity.components.timer > 0 then
        color[4] = math.max(0, entity.components.timer / 3)
    else
        ecs.removeAllEntitiesOfType("announcement")
    end
end, "update")


ecs.createSystem("achievementUpdate", { "timer", "color" }, function(dt, entity)
    if entity.components.type ~= "achievement" then return end

    entity.components.timer = entity.components.timer - dt


    local color = entity.components.color
    if entity.components.timer > 0 then
        color[4] = math.max(0, entity.components.timer / 3)
    else
        ecs.removeAllEntitiesOfType("achievement")
    end
end, "update")


ecs.createSystem("announcementRender", { "position", "size", "text", "color", "type" }, function(entity)
    if entity.components.type ~= "announcement" then return end

    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 24))



    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    local text = entity.components.text
    local color = entity.components.color


    love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
    love.graphics.print(text, x, y, 0, 1, 1)
end, "render")

ecs.createSystem("achievementRender", { "position", "size", "text", "image", "color", "type" }, function(entity)
    if entity.components.type ~= "achievement" then return end
    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 16))

    local position = entity.components.position
    local size = entity.components.size
    local text = entity.components.text
    local image = entity.components.image
    local color = entity.components.color


    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.draw(image, position.x, position.y, 0, 4, 4)


    love.graphics.setColor(colors.greens.border[1], colors.greens.border[2], colors.greens.border[3],
        color[4])
    love.graphics.print("Achievement unlocked", position.x + 20, position.y + size.height / 2)
    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 16))

    love.graphics.print(text, position.x + 20, position.y + size.height / 2 + 25)
end, "render")


ecs.createSystem("progressBarRender", { "position", "size", "color", "value", "maxValue" }, function(entity)
    if entity.components.type ~= "hud_bar" then return end


    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    local color = entity.components.color
    local value = entity.components.value
    local maxValue = entity.components.maxValue



    love.graphics.setColor(colors.greens.shadow)
    love.graphics.rectangle("fill", x, y, width, height)


    love.graphics.setColor(colors.greens.highlight2)
    local filledWidth = (value / maxValue) * width
    love.graphics.rectangle("fill", x, y + 5, filledWidth, height - 10)


    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(tostring(math.floor(value)), x, y + (height / 2) - 16, width, "center")
end, "render")

return hud
