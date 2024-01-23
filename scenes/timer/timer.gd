extends Label

@export var time_limit_seconds: int = 360
var timer: SceneTreeTimer

signal timeout


func _ready() -> void:
	start_timer()


func start_timer() -> void:
	timer = get_tree().create_timer(time_limit_seconds)
	timer.timeout.connect(func(): timeout.emit())


func get_time_left() -> float:
	return timer.time_left


func get_pretty_time(time: float) -> String:
	var minutes := int(time / 60)
	var seconds := int(time - 60 * minutes)
	var milliseconds := int((time - 60 * minutes - seconds) * 100)

	return "%d:%02d:%02d" % [minutes, seconds, milliseconds]


func _process(_delta):
	text = get_pretty_time(timer.time_left)
