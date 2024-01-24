extends Node

@export_multiline var text: String = "":
	set(new_text):
		running = false
		if textBox:
			textBox.visible_characters = 0
			textBox.text = new_text
		text = new_text
@export var characters_per_second: float = 25.0
@export var sentence_delay_seconds: float = 0.125
@export var paragraph_delay_seconds: float = 0.75

var textBox
var running = false


func _ready() -> void:
	textBox = get_parent()
	assert(textBox is Label or textBox is RichTextLabel)

	textBox.visible_characters = 0
	textBox.text = text


var did_just_par_delay: bool = false


func get_delay_for_char(current_char: String) -> float:
	if current_char == "\n" and not did_just_par_delay:
		did_just_par_delay = true
		return paragraph_delay_seconds

	did_just_par_delay = false

	if current_char == "." or current_char == "?" or current_char == "!":
		return sentence_delay_seconds

	return 1.0 / characters_per_second


func reveal_text(start_running = true) -> void:
	# Let us be interrupted
	if start_running:
		running = true
	if not running:
		return

	if textBox.visible_characters == text.length():
		return

	textBox.visible_characters += 1
	var current_char = textBox.text.substr(textBox.visible_characters - 1, 1)

	var delay: float = get_delay_for_char(current_char)
	await get_tree().create_timer(delay).timeout

	reveal_text(false)


func calculate_time_to_reveal(text_to_calc: String = "") -> float:
	var calc_text = text_to_calc if text_to_calc else text

	var total = 0.0
	for i in range(calc_text.length()):
		var current_char = calc_text.substr(i - 1, 1)
		total += get_delay_for_char(current_char)

	did_just_par_delay = false

	return total
