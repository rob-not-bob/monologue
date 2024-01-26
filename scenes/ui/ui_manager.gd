class_name UIController
extends Node

@onready var UIScreenToNode: Dictionary = {
	UISlice.Screens.Title: $TitleUI,
	UISlice.Screens.Main: $MainUI,
	UISlice.Screens.Pause: $PauseUI,
	UISlice.Screens.Success: $SuccessUI,
	UISlice.Screens.Fail: $FailUI,
	UISlice.Screens.None: null,
}


func _ready() -> void:
	Store.redux.subscribe(_on_screen_change, "s.ui.current_screen")
	Store.redux.dispatch(UISlice.change_screen(UISlice.Screens.None))


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
