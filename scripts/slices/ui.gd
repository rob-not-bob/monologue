class_name UISlice
extends Node


static func reducer(s: Dictionary, action: Redux.Action) -> Dictionary:
	match action.type:
		"TOGGLE_PAUSE":
			return {
				"is_game_paused": !s.is_game_paused,
			}
		"SET_SHOW_MONOLOGUE":
			return {
				"is_monologue_showing": action.d.show_monologue,
			}
		"CHANGE_SCREEN":
			return {
				"current_screen": action.d.screen,
			}
		"HIDE_OVERLAYS":
			return {"is_game_paused": false, "is_monologue_showing": false}

	return {}


func sagas(action: Redux.Action) -> Redux.Action:
	match action.type:
		"QUIT_GAME":
			get_tree().quit()

	return action


static var slice: Redux.Slice = (
	Redux
	. Slice
	. new(
		"ui",
		{
			"current_screen": Screens.Main,
			"is_game_paused": false,
			"is_monologue_showing": false,
			"success_message": "",
		},
	)
)


static func toggle_pause() -> Redux.Action:
	return slice.create_action("TOGGLE_PAUSE")


static func set_show_monologue(show_monologue: bool) -> Redux.Action:
	return slice.create_action("SET_SHOW_MONOLOGUE", {"show_monologue": show_monologue})


static func hide_overlays() -> Redux.Action:
	return slice.create_action("HIDE_OVERLAYS")


static func retry_game() -> Redux.Action:
	return slice.create_action("RETRY_GAME")


static func quit_game() -> Redux.Action:
	return slice.create_action("QUIT_GAME")


enum Overlays {
	Pause,
	Monologue,
	None,
}

enum Screens {
	Title,
	Main,
	Fail,
	Success,
}


static func change_screen(screen: Screens) -> Redux.Action:
	return slice.create_action("CHANGE_SCREEN", {"screen": screen})


static func next_level() -> Redux.Action:
	return slice.create_action("NEXT_LEVEL")


func _ready() -> void:
	slice.set_reducer(reducer)
	slice.add_saga(sagas)

	Store.redux.add_slice(slice)
