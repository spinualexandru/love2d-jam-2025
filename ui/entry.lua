local main_menu = require('ui.main_menu')
local options = require('ui.options')
local game_over = require('ui.game_over')

local ui_interfaces = {
    interfaces = {
        main_menu = main_menu,
        options = options,
        game_over = game_over
    },
    getActionHandler = function(interface, id)
        for i, item in ipairs(interface.items) do
            if item.id == id then
                return item.action_handler
            end
        end
    end
}


return ui_interfaces
