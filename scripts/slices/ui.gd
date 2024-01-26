class_name UISlice
extends Node


static func reducer(_state: Dictionary, action: Redux.Action) -> Dictionary:
	match action.type:
		"PAUSE_GAME":
			return {
				"is_game_paused": true,
			}
		"RESUME_GAME":
			return {
				"is_game_paused": false,
			}
		"CHANGE_SCREEN":
			return {
				"current_screen": action.d.screen,
			}

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
			"current_screen": Screens.None,
			"is_game_paused": false,
			"success_message": "",
		},
	)
)


static func pause_game() -> Redux.Action:
	return slice.create_action("PAUSE_GAME")


static func resume_game() -> Redux.Action:
	return slice.create_action("RESUME_GAME")


static func retry_game() -> Redux.Action:
	return slice.create_action("RETRY_GAME")


static func quit_game() -> Redux.Action:
	return slice.create_action("QUIT_GAME")


enum Screens {
	Title,
	Main,
	Pause,
	Fail,
	Success,
	None,
}


static func change_screen(screen: Screens) -> Redux.Action:
	return slice.create_action("CHANGE_SCREEN", {"screen": screen})


static func next_level() -> Redux.Action:
	return slice.create_action("NEXT_LEVEL")


func _ready() -> void:
	slice.set_reducer(reducer)
	slice.add_saga(sagas)

	Store.redux.add_slice(slice)
