local ecs = require('engine.ecs')
local hud = require('engine.hud')
local colors = require('engine.colors')

local run = {}

function run.load()
    ecs.createEntity("run", {
        type = "run",
        name = "run",
        position = { x = 100, y = 100 },
        size = { width = 200, height = 50 },
        time = 1,
        startTime = love.timer.getTime(),
        totalPausedTime = 0,
        pauseStartTime = nil,
        formattedTime = "00:00",
        score = 0,
        isUpgrading = false,
        phase = {
            current = 1,
            progress = 0,
            image = love.graphics.newImage("assets/battery.png"),
            baseDuration = 30
        },
        scoreFont = love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 24)),
        isPaused = false
    })
    hud.announcement("Phase 1", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end
function run.setTime(entity)
    if entity.type ~= "run" or entity.components.isPaused then
        return
    end
    local currentTime = love.timer.getTime()
    local elapsedTime = currentTime - entity.components.startTime - entity.components.totalPausedTime
    local seconds = math.floor(elapsedTime)
    local milliseconds = math.floor((elapsedTime - seconds) * 1000)
    entity.components.formattedTime = string.format("%02d:%03d", seconds, milliseconds)
    entity.components.time = elapsedTime
end

ecs.createSystem("scoreRender", { "type", "score" }, function(entity)
    if entity.type ~= "run" then
        return
    end

    love.graphics.setColor(colors.hexToRgb("#9bbc0f"))
    love.graphics.setFont(love.graphics.newFont("assets/DepartureMono-Regular.otf", 26))
    love.graphics.print("Energy: " .. require('game.player').getPoints(), 60, 150)
end, "render")
function run.getTime()
    return ecs.getEntitiesByType("run")[1].components.time
end

function run.getFormattedTime()
    return ecs.getEntitiesByType("run")[1].components.formattedTime
end

function run.getPhase()
    return ecs.getEntitiesByType("run")[1].components.phase.current
end

function run.getScore()
    return ecs.getEntitiesByType("run")[1].components.score
end

function run.setScore(score)
    ecs.getEntitiesByType("run")[1].components.score = score
end

function run.setIsUpgrading(isUpgrading)
    ecs.getEntitiesByType("run")[1].components.isUpgrading = isUpgrading
end

function run.getIsUpgrading()
    return ecs.getEntitiesByType("run")[1].components.isUpgrading
end

function run.getIsPaused()
    return ecs.getEntitiesByType("run")[1].components.isPaused
end

function run.setIsPaused(isPaused)
    local runEntity = ecs.getEntitiesByType("run")[1]
    runEntity.components.isPaused = isPaused
    if isPaused then
        runEntity.components.pauseStartTime = love.timer.getTime()
    else
        if runEntity.components.pauseStartTime then
            runEntity.components.totalPausedTime = runEntity.components.totalPausedTime + (love.timer.getTime() - runEntity.components.pauseStartTime)
            runEntity.components.pauseStartTime = nil
        end
    end
    print("Game is paused: " .. tostring(isPaused))
end

function shouldPhaseChange()
    local runEntity = ecs.getEntitiesByType("run")[1]
    return runEntity.components.time > runEntity.components.phase.baseDuration * runEntity.components.phase.current
end

--create input system to pause the game when Esc is pressed

ecs.createSystem("pauseGame", { "isPaused", "type" }, function(key)
    if key == 'p' then
        run.setIsPaused(not run.getIsPaused())
    end
end, "input")

ecs.createSystem("runTime", { "position", "size", "phase", "time", "startTime" }, function(dt, entity)
    if entity.type ~= "run" or entity.components.isPaused then
        return
    end

    local phase = entity.components.phase
    local currentPhase = phase.current
    local timeUntilNextPhase = phase.baseDuration * currentPhase
    local previousPhaseTime = phase.baseDuration * (currentPhase - 1)

    if entity.components.time > timeUntilNextPhase then
        phase.current = currentPhase + 1
        phase.progress = 0
        local player = ecs.getEntitiesByType("player")[1]
        player.components.points.multiplier = currentPhase
        hud.announcement("Phase " .. phase.current, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    else
        phase.progress = (entity.components.time - previousPhaseTime) / (timeUntilNextPhase - previousPhaseTime)
    end

    run.setTime(entity)
end, "update")

ecs.createSystem("energyBarRender", { "phase" }, function(entity)
    if entity.type ~= "run" or entity.components.isPaused then
        return
    end

    local phase = entity.components.phase
    local phaseProgress = phase.progress
    local phaseImage = phase.image

    local x = 60
    local y = (love.graphics.getHeight() / 2) - 85
    local width = 100
    local barMaxHeight = 128 * 2.7

    local progressBarHeight = barMaxHeight * phaseProgress
    love.graphics.setColor(colors.greens.highlight2)
    love.graphics.rectangle("fill", x + 20, love.graphics.getHeight() - 70, width - 40, -progressBarHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(phaseImage, x, y, 0, 3, 3)
end, "render")

return run