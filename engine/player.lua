local graphics = require('engine.graphics')
local colors = require('engine.colors')

local player = {
    x = 256,
    y = graphics.getScreenHeight() - 128,
    width = 32,
    height = 32,
    speed = 100,
    image = graphics.loadSpriteSheet("assets/player.png", 16, 24),
    isJumping = false,
    velocityY = 0,  -- Vertical velocity
    gravity = 1000, -- Gravity strength
    jumpStrength = -300,
    fallSound = love.audio.newSource("assets/fall.wav", "static")
}

function player.load()
    print("Player loaded")
    player.x = 100
    player.y = love.graphics.getHeight() - player.height
end

function player.update(dt)
    -- Horizontal movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        if player.x > 0 then
            player.x = player.x - player.speed * dt
        else
            player.x = 0
        end
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        if player.x < graphics.getScreenWidth() - player.width then
            player.x = player.x + player.speed * dt
        else
            player.x = graphics.getScreenWidth() - player.width
        end
    end

    -- Jump logic
    if not player.isJumping then
        if love.keyboard.isDown("space") then
            player.isJumping = true
            player.velocityY = player.jumpStrength
        end
    end

    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        player.speed = 300
    else
        player.speed = 100
    end

    -- Apply gravity if jumping
    if player.isJumping then
        player.velocityY = player.velocityY + player.gravity * dt
        player.y = player.y + player.velocityY * dt

        if player.y >= graphics.getScreenHeight() - player.height then
            player.y = graphics.getScreenHeight() - player.height
            player.isJumping = false
            player.velocityY = 0
            if player.fallSound then
                player.fallSound:stop() -- Stop any currently playing sound
                player.fallSound:play()
            end
        end
    end
end

function player.draw()
    oldColor = { love.graphics.getColor() }
    love.graphics.setColor(colors.flamingo)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(oldColor)
end

return player
