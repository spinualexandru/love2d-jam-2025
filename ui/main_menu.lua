local state = require('engine.state')

local main_menu = {
    name = "main_menu",
    default_item = "options",
    items = {
        {
            name = "Start",
            id = "start",
            action = "start",
            action_handler = function()
                state.switch("game")
            end,
            type = "button"
        },






        {
            id = "exit",
            name = "Exit",
            action = "exit",
            action_handler = function()
                love.event.quit()
            end,
            type = "button"
        }
    }
}

return main_menu
