local physics = require('game.physics')
local graphics = require('engine.graphics')
local lightShader = love.graphics.newShader("shaders/player_light_shader.glsl")

local player = {}
local jumpCount = 0
local playerBody, playerShape, playerFixture
playerDirection = 1

local playerImage -- Declare the player image variable

function player.load()
    -- Ensure physics.world is initialized
    if not physics.world then
        error("Physics world is not initialized. Call physics.load() before player.load().")
    end

    -- Initialize player physics body
    playerBody = love.physics.newBody(physics.world, 16 * 3, graphics.getScreenHeight() - 60 * 3, "dynamic")
    playerBody:setFixedRotation(true)                    -- Prevent the player from rotating

    playerShape = love.physics.newRectangleShape(32, 50) -- Player size
    playerFixture = love.physics.newFixture(playerBody, playerShape)
    playerFixture:setUserData("player")

    -- Load the player image
    playerImage = love.graphics.newImage("assets/player.png")
end

function player.update(dt)
    -- Update player position based on physics body
    local px, py = playerBody:getPosition()

    if playerBody == nil and not physics.world == nil then
        player.load()
    end
    -- Horizontal movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerBody:setX(math.max(playerBody:getX() - 200 * dt, 26 * 3))
        playerDirection = -1
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        -- move left and ensure the player falls if they get off an object
        playerBody:setX(math.min(playerBody:getX() + 200 * dt, graphics.getScreenWidth() - 32 * 3))
        playerDirection = 1
    end
end

function player.beginContact(a, b, coll)
    local userDataA = a:getUserData()
    local userDataB = b:getUserData()

    -- Reset jump count if the player lands
    if userDataA == "player" or userDataB == "player" then
        jumpCount = 0
    end
end

function player.draw()
    local px, py = playerBody:getPosition() -- Get the player's position

    if playerImage then
        -- Draw the player image centered on the player's position
        love.graphics.draw(playerImage, px, py, 0, 2 * playerDirection, 2, playerImage:getWidth() / 2,
            playerImage:getHeight() / 2)
    else
        -- Fallback: Draw the player shape if the image is not loaded
        love.graphics.polygon("fill", playerBody:getWorldPoints(playerShape:getPoints()))
    end
end

function player.resetJumpCount()
    jumpCount = 0
end

function player.keypressed(key)
    -- Jump logic using love.keypressed
    if key == "space" and jumpCount < 2 then
        playerBody:applyLinearImpulse(0, -300) -- Apply upward impulse for jumping
        jumpCount = jumpCount + 1              -- Increment the jump count
    end
end

function player.getPosition()
    return playerBody:getPosition()
end

return player
