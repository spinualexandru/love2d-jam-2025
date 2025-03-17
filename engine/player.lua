local graphics = require('engine.graphics');
local player = {
    x = 256,
    y = 256,
    width = 16,
    height = 24,
    speed = 0,
    image = graphics.loadSpriteSheet("assets/player.png", 16, 24),
    isFront = false,
    frame = 9,
    frameCount = 9,
    currentFrame = 9,
    frameInterval = 0.2,
    maxFrame = 30,
    frameTimer = 0,
}

function player.load()
    print("Player loaded")
    player.x = 100
    player.y = 100
    player.width = 16
    player.height = 24
    player.speed = 200
    player.image = graphics.loadSpriteSheet("assets/player.png", 16, 24)
    player.isFront = true
end

function player.update(dt)
    player.frameTimer = player.frameTimer + dt
    if player.frameTimer >= player.frameInterval then
        player.frameTimer = 0
        player.currentFrame = player.currentFrame + 1
        if player.currentFrame > player.maxFrame then
            player.currentFrame = player.frame
        end
    end
end

function player.draw()
    print("Player loadedx")
    if (player.image) then
        graphics.drawFromTo(player.image, player.currentFrame, player.currentFrame, player.x, player.y)
    end
end

return player
