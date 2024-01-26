class_name Redux
extends RefCounted

var _state: Dictionary
var _slices: Dictionary = {}
var _middleware: Array[Callable]

const _callbacks_key_name: String = "__callbacks"
var _state_subscriptions: Dictionary = {
	_callbacks_key_name: [],
}


func _init() -> void:
	_state = {}


func add_slice(slice: Slice) -> void:
	assert(not slice.name in _state, "ERROR: '%s' is already defined in state" % slice.name)
	assert(not slice.name in _slices, "ERROR: '%s' is already defined in slices" % slice.name)

	_slices[slice.name] = slice
	_state[slice.name] = slice.initial_state


func state() -> Dictionary:
	return _state


func add_middleware(middleware: Callable):
	_middleware.append(middleware)


func dispatch(action) -> void:
	var middleware_action: Action = action
	for middleware in _middleware:
		middleware_action = middleware.call(middleware_action)

	var split_action = middleware_action.type.split(":")
	var slice_name: String = split_action[0]
	var slice_action_name: String = split_action[1]

	assert(slice_name in _state, "ERROR: '%s' is not defined in state" % slice_name)
	assert(slice_name in _slices, "ERROR: '%s' is not defined in slices" % slice_name)

	var slice: Slice = _slices[slice_name]
	var slice_action := Action.new(slice_action_name, middleware_action.d)
	for saga in slice.sagas:
		saga.call(slice_action)

	var _new_state = slice.reducer.call(_state[slice_name], slice_action)
	_state[slice_name].merge(_new_state, true)

	# Notify subscribers of state changes
	for cb in _state_subscriptions[_callbacks_key_name]:
		cb.call(_state)

	_notify_subs({slice_name: _new_state}, _state_subscriptions)


# Subscribe to a particular path in the state
func subscribe(callback: Callable, path: String = "state"):
	var paths = path.split(".")
	var current_sub_location: Dictionary = _state_subscriptions
	var current_state_location: Dictionary = _state

	# Traverse the _state and _state_subscriptions dictionary
	# Check to make sure the path exists in _state
	# and also create the path _state_subscriptions if it doesn't exist
	for i in range(paths.size()):
		var segment: String = paths[i]
		if i == 0:
			assert(
				segment == "state" or segment == "s",
				"ERROR: First part of path must begin with 'state' or 's'"
			)
			continue

			assert(
				segment in current_state_location,
				"ERROR: '%s' does not exist in the state. Cannot subscribe!"
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


class Slice:
	var name: String
	var initial_state: Dictionary
	var reducer: Callable
	var sagas: Array[Callable]

	func _init(_name: String, _initial_state: Dictionary) -> void:
		name = _name
		initial_state = _initial_state

	func create_action(action: String, data: Dictionary = {}) -> Action:
		return Action.new("%s:%s" % [name, action], data)

	func set_reducer(_reducer: Callable):
		reducer = _reducer

	func add_saga(saga: Callable):
		sagas.append(saga)


class Action:
	var type: String
	var d: Dictionary

	func _init(_type: String, data = {}) -> void:
		type = _type
		d = data

	func _to_string() -> String:
		return "'%s': %s" % [type, d]
