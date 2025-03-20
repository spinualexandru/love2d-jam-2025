local json = require('libs.json4lua')

local conf = {
    settings = {}
}

function conf.load()
    encoded_json = love.filesystem.read("settings.json")
    conf.settings = json.decode(encoded_json)
    love.window.setMode(conf.settings.display.resolution.width, conf.settings.display.resolution.height, {
        vsync = conf.settings.display.vsync,
        fullscreen = conf.settings.display.fullscreen,
        resizable = true,
        minwidth = 800,
        minheight = 600,
        centered = true,
        msaa = conf.settings.display.msaa,
        borderless = conf.settings.display.borderless
    })

    conf.G_PLAYER_NAME = conf.settings.player.name
end

function conf.loadMetadata()
    local encoded_metadata = love.filesystem.read("metadata.json")
    G_METADATA = json.decode(encoded_metadata)
end

function conf.change_setting(setting, value)
    local unparsed_json = love.filesystem.read("settings.json")
    local parsed_settings = json.decode(unparsed_json)

    parsed_settings[setting] = value
    local new_settings = json.encode(parsed_settings)
    love.filesystem.write("settings.json", new_settings)
end

return conf
