class_name GridTile
extends Node

var tileType
var solid: bool = false
var pathWeight: float = 1.0
var node: Node
var delay_turns: int = 0
var num_available: int = 99


func _to_string() -> String:
	return (
		"solid=%s pathWeight=%s node=%s delay=%d num_available=%d"
		% [solid, pathWeight, node, delay_turns, num_available]
	)
