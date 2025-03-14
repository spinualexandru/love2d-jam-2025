local main_menu = {
    name = "main_menu",
    default_item = "options",
    items = {
        {
            name = "Continue",
            id = "continue",
            action = "continue",
            disabled = true,
            type = "button"
        },
        {
            name = "Start",
            id = "start",
            action = "start",
            type = "button"
        },
        {
            id = "load_game",
            name = "Load Game",
            action = "load_game",
            opens = "load_game",
            type = "button"
        },
        {
            id = "options",
            name = "Options",
            action = "options",
            opens = "options",
            type = "button"
        },
        {
            id = "exit",
            name = "Exit",
            action = "exit",
            type = "button"
        }
    }
}

return main_menu
