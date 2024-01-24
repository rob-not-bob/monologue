class_name Indicator
extends Node2D

var current_tile: Node2D


func _ready() -> void:
	G.indicator = self


func set_tile(tile_scene: PackedScene, num_tiles: int) -> void:
	if current_tile:
		current_tile.queue_free()
	current_tile = tile_scene.instantiate()
	$tile_parent.add_child(current_tile)

	set_num_tiles(num_tiles)


func set_num_tiles(num_tiles: int) -> void:
	$num_tiles_label.text = str(num_tiles)
