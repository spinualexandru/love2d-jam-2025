local graphics = {
    shader = {
        canvasList = {},
    }
}

function graphics.getScreenHeight()
    return love.graphics.getHeight()
end

function graphics.getScreenWidth()
    return love.graphics.getWidth()
end

function graphics.getScreenSize()
    return love.graphics.getWidth(), love.graphics.getHeight()
end

function graphics.shader.load()
    graphics.shader.addCanvas("main")

    graphics.shader.crt = love.graphics.newShader("crt_shader.glsl")
end

function graphics.shader.addCanvas(name)
    graphics.shader.canvasList[name] = love.graphics.newCanvas()
end

function graphics.shader.setCanvas(name)
    love.graphics.setCanvas(graphics.shader.canvasList[name])
end

function graphics.shader.resetCanvas()
    love.graphics.setCanvas()
end

function graphics.shader.drawCanvas(name, x, y)
    love.graphics.draw(graphics.shader.canvasList[name], x, y)
end

function graphics.shader.setShader(shader)
    love.graphics.setShader(shader)
end

function graphics.shader.update(dt)
    graphics.shader.crt:send("time", love.timer.getTime())
    graphics.shader.crt:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })
end

function graphics.shader.draw()
    love.graphics.setCanvas()
    love.graphics.setShader(graphics.shader.crt)
    love.graphics.draw(graphics.shader.canvasList["main"], 0, 0)
    love.graphics.setShader()
end

return graphics
