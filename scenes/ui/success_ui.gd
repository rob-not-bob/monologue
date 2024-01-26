extends Control

@onready var messageLabel: Label = $CenterContainer/VBoxContainer/Message


func _ready() -> void:
	Store.redux.subscribe(set_message, "s.ui.success_message")


func set_message(message: String) -> void:
	messageLabel.text = message


func _on_next_level_button_pressed() -> void:
	Store.redux.dispatch(UISlice.next_level())
