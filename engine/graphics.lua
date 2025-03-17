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

function graphics.loadSpriteSheet(fileName, width, height)
    local image = love.graphics.newImage(fileName)
    image:setFilter("nearest", "nearest")
    local spriteSheet = {}
    spriteSheet.image = image
    spriteSheet.width = width
    spriteSheet.height = height
    -- scale


    spriteSheet.quads = {}
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(spriteSheet.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    return spriteSheet
end

function graphics.drawSprite(spriteSheet, index, x, y)
    love.graphics.draw(spriteSheet.image, spriteSheet.quads[index], x, y)
end

function graphics.drawSpirteSheetAnimation(spriteSheet, animation, x, y)
    love.graphics.draw(spriteSheet.image, spriteSheet.quads[animation.frame], x, y)
end

function graphics.drawFromTo(spriteSheet, from, to, x, y)
    for i = from, to do
        love.graphics.draw(spriteSheet.image, spriteSheet.quads[i], x, y, 0, 4, 4)
    end
end

return graphics
