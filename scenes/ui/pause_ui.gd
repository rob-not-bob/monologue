extends Control


signal resume()
signal back_to_trap_placement()
signal back_to_title_screen()
signal exit_game()


func _on_resume_button_pressed() -> void:
	resume.emit()


func _on_to_trap_placement_button_pressed() -> void:
	back_to_trap_placement.emit()


func _on_to_title_screen_button_pressed() -> void:
	back_to_title_screen.emit()


func _on_exit_game_pressed() -> void:
	exit_game.emit()
