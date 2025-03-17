local main_menu_scene = require('game.main_menu_scene')
local game_scene = require('game.game_scene')
local state = require('engine.state')

local scenes = {}
function scenes.initialize()
    state.register("main_menu", main_menu_scene.draw, main_menu_scene.update, main_menu_scene.load)
    state.register("game", game_scene.draw, game_scene.update, game_scene.load)
    state.switch("main_menu")
end

return scenes
