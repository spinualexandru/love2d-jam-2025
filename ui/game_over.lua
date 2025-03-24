local state = require('engine.state')

local main_menu = {
    name = "game_over",
    default_item = "back",
    items = {
        {
            name = "Back to main menu",
            id = "back_to_main_menu",
            action = "game_over",
            action_handler = function()
                state.switch("main_menu")
            end,
            type = "button"
        },
        {
            id = "exit_game",
            name = "Exit Game",
            action = "exit",
            action_handler = function()
                love.event.quit()
            end,
            type = "button"
        }
    }
}

return main_menu
