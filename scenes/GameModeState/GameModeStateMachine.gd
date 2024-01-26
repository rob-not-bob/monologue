class_name GameModeStateMachine
extends StateMachine


func _process(delta: float) -> void:
	if Store.redux.state().ui.is_game_paused:
		return

	super(delta)
