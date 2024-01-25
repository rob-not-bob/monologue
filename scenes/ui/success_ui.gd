extends Control

@onready var messageLabel: Label = $CenterContainer/VBoxContainer/Message

signal next_level()

func set_message(message: String) -> void:
	messageLabel.text = message


func _on_next_level_button_pressed() -> void:
	next_level.emit()
