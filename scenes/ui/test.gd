class_name UIDriver
extends Node

signal transitioned_halfway
signal transitioned_fully


func transition_to_scene(scene_path: String) -> void:
	transition()
	await self.transitioned_halfway
	get_tree().change_scene_to_file(scene_path)


func transition() -> void:
	pass
	#if animation_player.is_playing():
	#	animation_player.stop()
	#animation_player.play("wipe")

# Overlay screen manager
# responsible for making sure only one overlay screen is present on screen at a time
# needs to connect the signals in those screens to functions

# Scene transistioner
# Responsible for transistioning between scenes and doing so in a cool way
# State machine?
