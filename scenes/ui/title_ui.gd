extends Control

signal start_game()
signal exit_game()


func _on_start_game_button_pressed() -> void:
	start_game.emit()


func _on_exit_game_button_pressed() -> void:
	exit_game.emit()
