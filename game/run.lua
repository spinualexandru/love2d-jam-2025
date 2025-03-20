local ecs = require('engine.ecs')
local hud = require('engine.hud')

local run = {
}


function run.load()
    ecs.createEntity("run", {
        type = "run",
        name = "run",
        position = { x = 100, y = 100 },
        size = { width = 200, height = 50 },
        phase = 1,
        time = 1,
        startTime = love.timer.getTime(),
        formattedTime = "00:00",
    })
    hud.announcement("Phase 1", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function run.setTime(entity)
    -- increase time in format seconds:milliseconds
    local currentTime = love.timer.getTime()
    local elapsedTime = currentTime - entity.components.startTime
    local seconds = math.floor(elapsedTime)
    local milliseconds = math.floor((elapsedTime - seconds) * 1000)
    ecs.getEntitiesByType("run")[1].components.formattedTime = string.format("%02d:%03d", seconds, milliseconds)
    ecs.getEntitiesByType("run")[1].components.time = elapsedTime
end

function run.getTime()
    return ecs.getEntitiesByType("run")[1].components.time
end

function run.getFormattedTime()
    return ecs.getEntitiesByType("run")[1].components.formattedTime
end

ecs.createSystem("runTime", { "position", "size", "phase", "time", "startTime" }, function(dt, entity)
    if entity.type ~= "run" then
        return
    end


    -- Update the HUD bar with the formatted time
    run.setTime(entity)
end, "update")

return run
