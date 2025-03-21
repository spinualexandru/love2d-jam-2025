local ecs = require('engine.ecs')
local run = require('game.run')

local energyBall = {}

function energyBall.spawn(from, to)
    ecs.createEntity("energy_ball", {
        type = "energy_ball",
        name = "energy_ball",
        position = { x = from.x, y = from.y },
        size = { width = 20, height = 20 },
        velocity = { x = to.x - from.x, y = to.y - from.y },
        image = love.graphics.newImage("assets/projectile.png"),
        speed = 300,
        damage = 10
    })
end

ecs.createSystem("energyBallShoot", { "position", "velocity", "speed" }, function(dt, entity)
    if entity.type ~= "energy_ball" then
        return
    end

    if run.getIsPaused() then
        return
    end
    local dx, dy = entity.components.velocity.x, entity.components.velocity.y
    local speed = entity.components.speed
    local distance = math.sqrt(dx * dx + dy * dy)
    local nx, ny = dx / distance, dy / distance
    entity.components.position.x = entity.components.position.x + nx * speed * dt
    entity.components.position.y = entity.components.position.y + ny * speed * dt
end, "update")

ecs.createSystem("energyBallRender", { "position", "size", "image" }, function(entity)
    if entity.type ~= "energy_ball" then
        return
    end
    love.graphics.setColor(1, 1, 1)
    local x, y = entity.components.position.x, entity.components.position.y
    local width, height = entity.components.size.width, entity.components.size.height
    love.graphics.draw(entity.components.image, x, y, 0, 2, 2)
end, "render")

return energyBall
