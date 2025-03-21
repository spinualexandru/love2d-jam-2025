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

function graphics.loadSpriteSheetAnimation(image, width, height, duration, gap)
    local spriteSheet = {}
    spriteSheet.image = image
    spriteSheet.width = width
    spriteSheet.height = height
    spriteSheet.duration = duration
    spriteSheet.gap = gap
    spriteSheet.frames = {}
    spriteSheet.currentTime = 0
    spriteSheet.currentFrame = 1
    spriteSheet.playing = false
    spriteSheet.loop = false
    spriteSheet.finished = false
    spriteSheet.flip = 1
    spriteSheet.x = 0
    spriteSheet.y = 0
    spriteSheet.scale = 1
    spriteSheet.rotation = 0
    spriteSheet.originX = 0
    spriteSheet.originY = 0
    spriteSheet.color = { 1, 1, 1, 1 }
    spriteSheet.quad = love.graphics.newQuad(0, 0, width, height, image:getWidth(), image:getHeight())
    return spriteSheet
end

function graphics.updateSpriteSheetAnimation(spriteSheet, dt)
    if spriteSheet.playing then
        spriteSheet.currentTime = spriteSheet.currentTime + dt
        if spriteSheet.currentTime >= spriteSheet.duration then
            spriteSheet.currentTime = spriteSheet.currentTime - spriteSheet.duration
            spriteSheet.currentFrame = spriteSheet.currentFrame + 1
            if spriteSheet.currentFrame > #spriteSheet.frames then
                if spriteSheet.loop then
                    spriteSheet.currentFrame = 1
                else
                    spriteSheet.currentFrame = #spriteSheet.frames
                    spriteSheet.finished = true
                    spriteSheet.playing = false
                end
            end
            spriteSheet.quad:setViewport((spriteSheet.currentFrame - 1) * spriteSheet.width, 0, spriteSheet.width, spriteSheet.height)
        end
    end
end

function graphics.drawSpriteSheetAnimation(spriteSheet)
    love.graphics.setColor(spriteSheet.color)
    love.graphics.draw(spriteSheet.image, spriteSheet.quad, spriteSheet.x, spriteSheet.y, spriteSheet.rotation, spriteSheet.flip, 1, spriteSheet.originX, spriteSheet.originY)
    love.graphics.setColor(1, 1, 1, 1)
end

return graphics
