class_name UISlice
extends Node


static func reducer(state: Dictionary, action: Redux.Action) -> Dictionary:
	match action.type:
		"PAUSE_GAME":
			return {
				"ui":
				{
					"is_game_paused": true,
				}
			}
		"RESUME_GAME":
			return {
				"ui":
				{
					"is_game_paused": false,
				}
			}
		"CHANGE_SCREEN":
			return {
				"ui":
				{
					"current_screen": action.d.screen,
				}
			}
		"NEXT_LEVEL":
			return {
				"level":
				{
					"levelNumber": state.level.levelNumber + 1,
				}
			}

	return {}


func sagas(action: Redux.Action) -> Redux.Action:
	match action.type:
		"QUIT_GAME":
			get_tree().quit()

	return action


static var ui_slice: Redux.Slice = (
	Redux
	. Slice
	. new(
		"ui",
		{
			"current_screen": "title",
			"is_game_paused": false,
			"success_message": "",
		},
	)
)


static func pause_game() -> Redux.Action:
	return ui_slice.create_action("PAUSE_GAME")


static func resume_game() -> Redux.Action:
	return ui_slice.create_action("RESUME_GAME")


static func retry_game() -> Redux.Action:
	return ui_slice.create_action("RETRY_GAME")


static func quit_game() -> Redux.Action:
	return ui_slice.create_action("QUIT_GAME")


enum Screens {
	Title,
	Build,
	Runner,
}


static func change_screen(screen: Screens) -> Redux.Action:
	return ui_slice.create_action("CHANGE_SCREEN", {"screen": screen})


static func next_level() -> Redux.Action:
	return ui_slice.create_action("NEXT_LEVEL")


func _ready() -> void:
	ui_slice.set_reducer(reducer)
	ui_slice.add_saga(sagas)

	Store.redux.add_slice(ui_slice)
