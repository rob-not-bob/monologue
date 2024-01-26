class_name UIController
extends Node

@onready var UIScreenToNode: Dictionary = {
	UISlice.Screens.Title: $TitleUI,
	UISlice.Screens.Main: null,
	UISlice.Screens.Success: $SuccessUI,
	UISlice.Screens.Fail: $FailUI,
}

@onready var UIOverlayToNode: Dictionary = {
	UISlice.Overlays.Pause: $PauseUI,
	UISlice.Overlays.Monologue: $MonologueUI,
	UISlice.Overlays.None: null,
}


func _ready() -> void:
	Store.redux.subscribe(_on_screen_change, "s.ui.current_screen")
	Store.redux.subscribe(_on_paused_change, "s.ui.is_game_paused")
	Store.redux.subscribe(_on_show_monologue_changed, "s.ui.is_monologue_showing")
	Store.redux.dispatch(UISlice.hide_overlays())


func _on_paused_change(is_paused: bool):
	var pauseNode = UIOverlayToNode[UISlice.Overlays.Pause]
	if is_paused:
		pauseNode.show()
		Engine.time_scale = 0
	else:
		pauseNode.hide()
		Engine.time_scale = 1


func _on_show_monologue_changed(show_monologue: bool):
	var monologueNode = UIOverlayToNode[UISlice.Overlays.Monologue]
	if show_monologue:
		monologueNode.show()
	else:
		monologueNode.hide()


func _on_screen_change(new_screen) -> void:
	for screen in UIScreenToNode:
		if not UIScreenToNode[screen]:
			return
		if screen == new_screen:
			UIScreenToNode[screen].show()
		elif UIScreenToNode[screen]:
			UIScreenToNode[screen].hide()


func next_level():
	pass
