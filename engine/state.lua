local state = {}

local currentState
local states = {}

function state.register(name, drawFunction, updateFunction)
    states[name] = {
        draw = drawFunction,
        update = updateFunction
    }
end

function state.switch(newState)
    currentState = newState
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

function state.getCurrentState()
    return currentState
end

return state
