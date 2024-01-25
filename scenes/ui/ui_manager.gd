class_name UIController
extends Node

enum UIScreen { Title, Pause, Success, Fail, Main, None }

@onready var UIScreenToNode: Dictionary = {
	UIScreen.Title: $TitleUI,
	UIScreen.Pause: preload("res://scenes/ui/pause_ui.tscn"),
	UIScreen.Success: preload("res://scenes/ui/success_ui.tscn"),
	UIScreen.Fail: preload("res://scenes/ui/fail_ui.tscn"),
}

@export var initial_screen: UIScreen
var current_screen: UIScreen = UIScreen.None


func _ready() -> void:
	current_screen = initial_screen
	UIScreenToNode[current_screen].show()


func next_level():
	pass


func go_to_title_screen():
	pass


func go_to_trap_placement():
	pass


var is_paused := false


func toggle_pause():
	pass


func exit_game():
	get_tree().quit()
