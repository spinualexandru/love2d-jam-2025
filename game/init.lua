local hotreload = require("hotreload")
local settings = require('settings')
local ui = require('ui')
local events = require('events')
local graphics = require('graphics')
local scenes = require('scenes')


local init = {}


function initialize()
    love.graphics.setDefaultFilter("nearest", "nearest")
    hotreload.load()
    settings.load()
    settings.loadMetadata()
    ui.load()
    events.load()
    graphics.shader.load()
    scenes.initialize()
end

return init
