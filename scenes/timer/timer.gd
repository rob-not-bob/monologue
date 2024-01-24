class_name CountdownTimer
extends Label

@export var time_limit_seconds: float = 180.0
var timer: SceneTreeTimer

signal timeout


func _ready() -> void:
	text = get_pretty_time(time_limit_seconds)


func _process(_delta):
	if not timer:
		return

	text = get_pretty_time(timer.time_left)


func start() -> void:
	timer = get_tree().create_timer(time_limit_seconds)
	timer.timeout.connect(on_timeout)


func stop() -> void:
	timer.timeout.disconnect(on_timeout)
	timer = null


func reset() -> void:
	timer = null
	text = get_pretty_time(time_limit_seconds)


func get_time_left() -> float:
	return timer.time_left


func get_pretty_time(time: float) -> String:
	var minutes := int(time / 60)
	var seconds := int(time - 60 * minutes)
	var milliseconds := int((time - 60 * minutes - seconds) * 100)

	if time_limit_seconds >= 60:
		return "%d:%02d:%02d" % [minutes, seconds, milliseconds]
	else:
		return "%02d:%02d" % [seconds, milliseconds]


func on_timeout():
	timeout.emit()
