extends Control


func _on_start_game_button_pressed() -> void:
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.Build))


func _on_exit_game_button_pressed() -> void:
	Store.redux.dispatch(UISlice.quit_game())
