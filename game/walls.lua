local physics = require('game.physics')
local graphics = require('engine.graphics')

local walls = {
    objects = {},
    wallImage = nil
}
local wallScale = 3

function walls.load()
    walls.clear()


    walls.wallImage = love.graphics.newImage("assets/brick.png")


    local windowMode = love.window.getMode()
    local screenWidth = windowMode
    local screenHeight = love.graphics.getHeight()
    local wallWidth = walls.wallImage:getWidth() * wallScale
    local wallHeight = walls.wallImage:getHeight() * wallScale


    local numWallsBottom = math.ceil(screenWidth / wallWidth)
    local numWallsSide = math.ceil(screenHeight / wallHeight)


    for i = 0, numWallsBottom do
        local x = i * wallWidth + wallWidth / 2
        local y = screenHeight - wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end


    for i = 0, numWallsBottom do
        local x = i * wallWidth + wallWidth / 2
        local y = wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end


    for i = 0, numWallsSide do
        local x = wallWidth / 2
        local y = i * wallHeight + wallHeight / 2

        local wallBody = love.physics.newBody(physics.world, x, y, "static")
        local wallShape = love.physics.newRectangleShape(wallWidth, wallHeight)
        local wallFixture = love.physics.newFixture(wallBody, wallShape)
        wallFixture:setUserData("wall")

        table.insert(walls.objects, { body = wallBody, shape = wallShape })
    end


    for i = 0, numWallsSide do
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
    for _, wall in ipairs(walls.objects) do
        if wall.body and not wall.body:isDestroyed() then
            wall.body:destroy()
        end
    end
    walls.objects = {}
end

return walls
