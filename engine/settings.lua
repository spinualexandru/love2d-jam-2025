local json = require('libs.json4lua')

local conf = {}

function conf.loadSettings()
    encoded_json = love.filesystem.read("settings.json")
    settings = json.decode(encoded_json)
    love.window.setMode(settings.display.resolution.width, settings.display.resolution.height, {
        vsync = settings.display.vsync,
        fullscreen = settings.display.fullscreen,
        resizable = true,
        minwidth = 800,
        minheight = 600,
        centered = true,
        msaa = settings.display.msaa,
        borderless = settings.display.borderless
    })
end

return conf