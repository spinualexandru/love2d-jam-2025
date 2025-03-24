local main_menu_scene = require('game.main_menu_scene')
local game_scene = require('game.game_scene')
local game_over_scene = require('game.game_over_scene')
local state = require('engine.state')

local scenes = {
    soundtrack = love.audio.newSource("assets/soundtrack.wav", "stream"),
}

function scenes.initialize()
    state.register("game", game_scene.draw, game_scene.update, game_scene.load)
    state.register("main_menu", main_menu_scene.draw, main_menu_scene.update, main_menu_scene.load)
    state.register("game_over", game_over_scene.draw, game_over_scene.update, game_over_scene.load)
    state.switch("main_menu")
end

function scenes.update(dt)

end

return scenes
