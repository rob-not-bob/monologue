class_name Redux
extends RefCounted

var _state: Dictionary
var _reducer_callback: Callable
var _middleware: Array[Callable]

const _callbacks_key_name: String = "__callbacks"
var _state_subscriptions: Dictionary = {
	_callbacks_key_name: [],
}


func _init(initial_state: Dictionary, reducer_callback: Callable) -> void:
	_state = initial_state
	_reducer_callback = reducer_callback


func state() -> Dictionary:
	return _state


func add_middleware(middleware: Callable):
	_middleware.append(middleware)


func dispatch(action) -> void:
	var new_action = action
	for middleware in _middleware:
		new_action = middleware.call(new_action)

	var _new_state = _reducer_callback.call(_state, new_action)
	_state.merge(_new_state, true)

	# Notify subscribers of state changes
	for cb in _state_subscriptions[_callbacks_key_name]:
		cb.call(_state)

	_notify_subs(_new_state, _state_subscriptions)


# Subscribe to a particular path in the state
func subscribe(callback: Callable, path: String = "state"):
	var paths = path.split(".")
	var current_state_location: Dictionary = _state
	var current_sub_location: Dictionary = _state_subscriptions

	# Traverse the _state and _state_subscriptions dictionary
	# Check to make sure the path exists in _state
	# and also create the path _state_subscriptions if it doesn't exist
	for i in range(paths.size()):
		var segment: String = paths[i]
		if i == 0:
			assert(
				segment == "state" or segment == "s",
				"ERROR: First part of path must begin with 'state'"
			)
			continue

		# Check that the path exists in the state
		assert(
			segment in current_state_location,
			"ERROR: '%s' does not exist in state. Cannot subscribe!" % segment
		)

		if not segment in current_sub_location:
			current_sub_location[segment] = {_callbacks_key_name: []}

		if current_state_location[segment] is Dictionary:
			current_state_location = current_state_location[segment]
		current_sub_location = current_sub_location[segment]

	var callbacks: Array = current_sub_location.get(_callbacks_key_name)
	callbacks.append(callback)


# Traverses subs_location, calling all callbacks associated with the new_state
func _notify_subs(new_state: Dictionary, subs_location: Dictionary):
	for key in new_state:
		if not key in subs_location:
			continue

		for callback in subs_location[key][_callbacks_key_name]:
			callback.call(new_state[key])

		if new_state[key] is Dictionary:
			_notify_subs(new_state[key], subs_location[key])
