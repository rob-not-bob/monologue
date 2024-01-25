class_name UI
extends Control

@onready var textReveal = $Root/LeftCol/HBoxContainer/Panel/RichTextLabel/TextReveal
@onready var countdownTimer: CountdownTimer = %CountdownTimer


func _ready() -> void:
	randomize()
	countdownTimer.time_limit_seconds = textReveal.calculate_time_to_reveal()


func start_monologue() -> void:
	textReveal.reveal_text()
	countdownTimer.start()


var interrupt_lines: Array[String] = [
	"What the...?! How did you get here so fast?! I didn't expect to see you for at least another hour. This is not good, not good at all.",
	"Whoa, whoa, whoa! Hold up, Hero. I wasn't expecting you to burst in here like that. What's the meaning of this?",
	"Huh?! What are you doing here?! I thought I had at least another 10 minutes before you showed up. This is not according to plan.",
	"Wait, wait, wait! What's the big idea, Hero?! I'm right in the middle of something important here. Can't you see I'm busy?",
]


func interrupt() -> void:
	textReveal.text = interrupt_lines.pick_random()
	textReveal.reveal_text()
	countdownTimer.stop()
