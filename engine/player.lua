local graphics = require('engine.graphics')
local colors = require('engine.colors')

local player = {
    x = 256,
    y = 256,
    width = 32,
    height = 32,
    speed = 100,
    image = graphics.loadSpriteSheet("assets/player.png", 16, 24),

}

function player.load()
    print("Player loaded")
    player.x = 100
    player.y = 100
end

function player.update(dt)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        if player.y > 0 then
            player.y = player.y - player.speed * dt
        end
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        if player.y < graphics.getScreenHeight() - player.height then
            player.y = player.y + player.speed * dt
        else
            player.y = graphics.getScreenHeight() - player.height
        end
    end
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


    if love.keyboard.isDown("lshift") then
        player.speed = 400
    else
        player.speed = 100
    end
end

function player.draw()
    oldColor = { love.graphics.getColor() }
    love.graphics.setColor(colors.flamingo)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.setColor(oldColor)
end

return player
