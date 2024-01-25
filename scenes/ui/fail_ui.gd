extends Control

signal retry()
signal back_to_title_screen()
signal exit_game()



func _on_retry_button_pressed() -> void:
	retry.emit()


func _on_back_to_title_button_pressed() -> void:
	back_to_title_screen.emit()


func _on_exit_game_button_pressed() -> void:
	exit_game.emit()
