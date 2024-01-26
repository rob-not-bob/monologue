extends Node


func logger(action: Redux.Action) -> Redux.Action:
	if not OS.is_debug_build():
		return

	print("Action ", action)

	return action


var redux: Redux = Redux.new()


func _ready() -> void:
	redux.add_middleware(logger)
