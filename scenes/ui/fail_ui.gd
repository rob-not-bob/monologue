extends Control


func _on_retry_button_pressed() -> void:
	Store.redux.dispatch(UISlice.retry_game())


func _on_back_to_title_button_pressed() -> void:
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.Title))


func _on_exit_game_button_pressed() -> void:
	Store.redux.dispatch(UISlice.quit_game())
