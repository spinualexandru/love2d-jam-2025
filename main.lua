local hotreload = require("engine.hotreload")
local settings = require('engine.settings')
local ui = require('engine.ui')
local events = require('events')
local state = require('engine.state')
local graphics = require('engine.graphics')
local scenes = require('game.scenes')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    hotreload.load()
    settings.load()
    settings.loadMetadata()
    ui.load()
    events.load()
    graphics.shader.load()
    scenes.initialize()
end

function love.update(dt)
    hotreload.update(dt)
    events.update(dt)

    graphics.shader.update(dt)

    -- Update the current state
    state.update(dt)
end

function love.draw()
    -- Set the canvas to render the scene
    love.graphics.setCanvas(graphics.shader.canvasList["main"])

    state.draw()

    graphics.shader.draw()
end

love.keypressed = function(key)
    if key == "escape" then
        state.switch("main_menu")
    end
end
