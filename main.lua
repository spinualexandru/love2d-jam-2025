local hotreload = require("engine.hotreload")
local settings = require('engine.settings')
local colors = require('engine.colors')
local render = require('engine.render')
local ui = require('engine.ui')
local events = require('events')
local state = require('engine.state')
local graphics = require('engine.graphics')

-- Define the main menu state
local function mainMenuDraw()
    love.graphics.clear(colors.hexToRgb("#FBEED5"))
    love.graphics.setColor(colors.text)
    render.print("Main Menu", 10, 10, 32, colors.hexToRgb("#221D1E"), "assets/DepartureMono-Regular.otf")
    ui.draw()
end

local function mainMenuUpdate(dt)
    -- Add main menu-specific update code here
end

-- Define the game state
local function gameDraw()
    love.graphics.clear(colors.hexToRgb("#FBEED5"))
    love.graphics.setColor(colors.text)
    love.graphics.clear(colors.hexToRgb("#FBEED5"))

    render.print("Clues: X", 10, 10, 32, colors.hexToRgb("#221D1E"), "assets/DepartureMono-Regular.otf")
    ui.button({ name = "Back", action = "back" }, 10, 50, colors.hexToRgb("#FCD6A6"), function()
        state.switch("mainMenu")
    end)
    -- Add game-specific drawing code here
end

local function gameUpdate(dt)
    -- Add game-specific update code here
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    hotreload.load()
    settings.load()
    settings.loadMetadata()
    ui.load()
    events.load()
    graphics.shader.load()


    -- Register states
    state.register("mainMenu", mainMenuDraw, mainMenuUpdate)
    state.register("game", gameDraw, gameUpdate)

    -- Set the initial state to the main menu
    state.switch("mainMenu")
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
        state.switch("mainMenu")
    end
end
