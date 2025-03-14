local graphics = {}

function graphics.getScreenHeight()
    return love.graphics.getHeight()
end

function graphics.getScreenWidth()
    return love.graphics.getWidth()
end

function graphics.getScreenSize()
    return love.graphics.getWidth(), love.graphics.getHeight()
end

return graphics