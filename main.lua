local hotreload = require("engine.hotreload")
local settings = require('engine.settings')
local ui = require('engine.ui')
local events = require('events')
local state = require('engine.state')
local graphics = require('engine.graphics')
local scenes = require('game.scenes')
local player = require('game.player')
local ecs = require('engine.ecs')

local soundtrack
local isPaused = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    hotreload.load()
    settings.load()
    settings.loadMetadata()
    ui.load()
    events.load()
    graphics.shader.load()
    scenes.initialize()
    soundtrack = love.audio.newSource("assets/soundtrack.wav", "stream")
    soundtrack:setLooping(true)

    soundtrack:play()
end

function love.update(dt)
    hotreload.update(dt)
    events.update(dt)

    graphics.shader.update(dt)
    state.update(dt)

    if soundtrack ~= nil then
        if isPaused == false then
            if not soundtrack:isPlaying() then
                soundtrack:play()
            end
        else
            if soundtrack:isPlaying() then
                soundtrack:pause()
            end
        end
    end
end

function love.draw()
    love.graphics.setCanvas(graphics.shader.canvasList["main"])

    state.draw()

    graphics.shader.draw()
end

love.keypressed = function(key, scancode, isRepeat)
    if key == "escape" then
        state.switch("main_menu")
    end
    if key == "p" then
        isPaused = not isPaused
    end
    ecs.processKeyPress(key, scancode, isRepeat)
end
