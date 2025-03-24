local graphics = require('engine.graphics')
local colors = require('engine.colors')

local player = {
    x = 256,
    y = graphics.getScreenHeight() - 128,
    width = 32,
    height = 32,
    speed = 100,
    image = nil,
    isJumping = false,
    velocityY = 0,
    gravity = 1000,
    jumpStrength = -300,
    fallSound = love.audio.newSource("assets/fall.wav", "static")
}

function player.load()
    player.x = 100
    player.y = love.graphics.getHeight() - player.height
end

function player.update(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        if player.x > 32 then
            player.x = player.x - player.speed * dt
        else
            player.x = 32
        end
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        if player.x < graphics.getScreenWidth() - 16 - player.width then
            player.x = player.x + player.speed * dt
        else
            player.x = graphics.getScreenWidth() - 16 - player.width
        end
    end


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


    if player.isJumping then
        player.velocityY = player.velocityY + player.gravity * dt
        player.y = player.y + player.velocityY * dt

        if player.y >= graphics.getScreenHeight() - 16 - player.height then
            player.y = graphics.getScreenHeight() - 16 - player.height
            player.isJumping = false
            player.velocityY = 0
            if player.fallSound then
                player.fallSound:stop()
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
