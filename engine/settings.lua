local json = require('libs.json4lua')

local conf = {}

function conf.load()
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

    conf.G_PLAYER_NAME = settings.player.name
end

function conf.loadMetadata()
    local encoded_metadata = love.filesystem.read("metadata.json")
    G_METADATA = json.decode(encoded_metadata)
end

function conf.change_setting(setting, value)
    local unparsed_json = love.filesystem.read("settings.json")
    local parsed_settings = json.decode(unparsed_json)
    print(parsed_settings)
    parsed_settings[setting] = value
    local new_settings = json.encode(parsed_settings)
    love.filesystem.write("settings.json", new_settings)
end

return conf
