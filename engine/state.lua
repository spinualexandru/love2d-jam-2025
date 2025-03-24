local state = {}

local currentState
local states = {}

function state.register(name, drawFunction, updateFunction, loadFunction)
    states[name] = {
        draw = drawFunction,
        update = updateFunction,
        load = loadFunction
    }
end

function state.switch(newState)
    currentState = newState
    if states[newState] and states[newState].load then
        states[newState].load()
    end
end

function state.update(dt)
    if currentState and states[currentState] and states[currentState].update then
        states[currentState].update(dt)
    end
end

function state.draw()
    if currentState and states[currentState] and states[currentState].draw then
        states[currentState].draw()
    end
end

function state.load()
    state.switch("main_menu")
    for name, state in pairs(states) do
        if state.load then
            state.load()
        end
    end
end

function state.getCurrentState()
    return currentState
end

return state
