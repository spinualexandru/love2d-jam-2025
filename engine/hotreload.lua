local colors = require('engine.colors')
local render = require('engine.render')

local hotreload = {}

local function reloadModule(name)
    package.loaded[name] = nil
    return require(name)
end

local function isDevMode()
    -- get env var
    local env_var = os.getenv("DEV_MODE")

    if (env_var) then
        return true
    else
        return false
    end
end

function hotreload.isDevMode()
    return isDevMode()
end

function hotreload.load()
    hotreload_icon = love.graphics.newImage("assets/hotreload.png")
end

function hotreload.update(dt)
    if love.keyboard.isDown("r") and isDevMode() then
        reloadModule("main")
    end
end

function hotreload.draw()
    screenHeight = love.graphics.getHeight()
    if isDevMode() then
        love.graphics.draw(hotreload_icon, 10, screenHeight - hotreload_icon:getHeight() - 10) -- Adjust the y-coordinate for the image
        render.print("Dev Mode", 10 + hotreload_icon:getWidth() + 10, screenHeight - hotreload_icon:getHeight() - 5, 12, { 0, 0, 0 })
    end
end

return hotreload