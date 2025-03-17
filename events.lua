local ui_interfaces = require('ui.entry')
local conf = require('engine.settings')
local events = {}
events.handlers = {}

function events.on(event, handler)
    if not events.handlers[event] then
        events.handlers[event] = {}
    end
    table.insert(events.handlers[event], handler)
end

function events.emit(event, ...)
    if events.handlers[event] then
        for _, handler in ipairs(events.handlers[event]) do
            handler(...)
        end
    end
end

function events.exit()
    love.event.quit()
end

function events.update(dt)
    for n, a, b, c, d, e, f in love.event.poll() do
        if n == "exit" then
            love.event.quit()
        end
    end
end

function events.load()
    events.on("exit", ui_interfaces.getActionHandler(ui_interfaces.interfaces.main_menu, "exit"))
    events.on("continue", function() print("Continue") end)
    events.on("start", ui_interfaces.getActionHandler(ui_interfaces.interfaces.main_menu, "start"))
    events.on("load_game", function() print("Load Game") end)
end

return events
