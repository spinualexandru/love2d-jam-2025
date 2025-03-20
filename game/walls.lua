local physics = require('game.physics')
local graphics = require('engine.graphics')

local walls = {
    objects = {},
    wallImage = nil
}
local wallScale = 3

function walls.load()
    walls.clear()

    -- Load the wall texture
    walls.wallImage = love.graphics.newImage("assets/brick.png")

    -- Calculate wall dimensions
    local windowMode = love.window.getMode()
    local screenWidth = windowMode
    local screenHeight = love.graphics.getHeight()
    local wallWidth = walls.wallImage:getWidth() * wallScale
    local wallHeight = walls.wallImage:getHeight() * wallScale

    -- Calculate the number of walls needed for each side
    local numWallsBottom = math.ceil(screenWidth / wallWidth)
    local numWallsSide = math.ceil(screenHeight / wallHeight)

    -- Create walls across the bottom of the screen
    for i = 0, numWallsBottom do -- Add an extra wall to ensure full coverage
        local x = i * wallWidth + wallWidth / 2
        local y = screenHeight - wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end

    -- Create walls across the top of the screen
    for i = 0, numWallsBottom do -- Add an extra wall to ensure full coverage
        local x = i * wallWidth + wallWidth / 2
        local y = wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end

    -- Create walls along the left side of the screen
    for i = 0, numWallsSide do -- Add an extra wall to ensure full coverage
        local x = wallWidth / 2
        local y = i * wallHeight + wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end

    -- Create walls along the right side of the screen
    for i = 0, numWallsSide do -- Add an extra wall to ensure full coverage
        local x = screenWidth - wallWidth / 2
        local y = i * wallHeight + wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end
end

function walls.draw()
    for _, wall in ipairs(walls.objects) do
        local x, y = wall.body:getPosition()
        love.graphics.draw(walls.wallImage, x, y, 0, wallScale, wallScale, walls.wallImage:getWidth() / 2,
            walls.wallImage:getHeight() / 2)
    end
end

function walls.clear()
    -- Destroy all existing wall bodies
    for _, wall in ipairs(walls.objects) do
        if wall.body and not wall.body:isDestroyed() then
            wall.body:destroy()
        end
    end
    walls.objects = {} -- Clear the walls table
end

return walls
