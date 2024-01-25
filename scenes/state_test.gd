extends Node

enum Actions {
	PAUSE_GAME,
	RESUME_GAME,
	ADD_DAMAGE,
	QUIT_GAME,
}


class Action:
	var type: Actions
	var d: Dictionary

	func _init(_type: Actions, data = {}) -> void:
		type = _type
		d = data


func pause_game() -> Action:
	return Action.new(Actions.PAUSE_GAME)


func add_damage(damage: int) -> Action:
	return Action.new(Actions.ADD_DAMAGE, {"damage": damage})


func reducer(__state: Dictionary, action: Action) -> Dictionary:
	match action.type:
		Actions.PAUSE_GAME:
			return {
				"is_game_paused": true,
			}
		Actions.RESUME_GAME:
			return {
				"is_game_paused": false,
			}
		Actions.ADD_DAMAGE:
			return {
				"player": {"weapon": {"damage": __state.player.weapon.damage + action.d.damage}}
			}

	return {}


func side_effect_middleware(action: Action) -> Action:
	match action.type:
		Actions.QUIT_GAME:
			get_tree().quit()

	return action


var store = Redux.new(
	{"is_game_paused": false, "player": {"health": 100, "weapon": {"damage": 20}}}, reducer
)


func test(_new_is_paused):
	printt("new_is_paused", _new_is_paused)


func damage_sub(new_damage):
	printt("new_damage", new_damage)


func _ready() -> void:
	store.add_middleware(side_effect_middleware)

	print("init", store.state())
	store.subscribe(test, "s.is_game_paused")
	store.subscribe(damage_sub, "s.player.weapon.damage")
	print("init2", store._state_subscriptions)
	store.dispatch(Action.new(Actions.PAUSE_GAME))
	print("init3", store.state().is_game_paused)
	store.dispatch(add_damage(10))
	print("init3", store.state().player)
	store.dispatch(Action.new(Actions.QUIT_GAME))
