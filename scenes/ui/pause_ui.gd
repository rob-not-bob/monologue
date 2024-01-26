extends Control

signal resume
signal back_to_trap_placement
signal back_to_title_screen
signal exit_game

@onready
var back_to_trap_placement_button: Button = $CenterContainer/VBoxContainer/ToTrapPlacementButton


func _ready() -> void:
	Store.redux.subscribe(_on_monolgue_show_change, "s.ui.is_monologue_showing")
	back_to_trap_placement_button.hide()


func _on_monolgue_show_change(is_monologue_showing: bool):
	if is_monologue_showing:
		back_to_trap_placement_button.show()
	else:
		back_to_trap_placement_button.hide()


func _on_resume_button_pressed() -> void:
	Store.redux.dispatch(UISlice.toggle_pause())


func _on_to_trap_placement_button_pressed() -> void:
	pass
	#Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.None))


func _on_to_title_screen_button_pressed() -> void:
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.Title))


func _on_exit_game_pressed() -> void:
	Store.redux.dispatch(UISlice.quit_game())
