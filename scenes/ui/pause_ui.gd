extends Control

signal resume
signal back_to_trap_placement
signal back_to_title_screen
signal exit_game


func _on_resume_button_pressed() -> void:
	Store.redux.dispatch(UISlice.resume_game())


func _on_to_trap_placement_button_pressed() -> void:
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.None))


func _on_to_title_screen_button_pressed() -> void:
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.Title))


func _on_exit_game_pressed() -> void:
	Store.redux.dispatch(UISlice.quit_game())
