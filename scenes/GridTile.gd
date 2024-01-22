class_name GridTile
extends Node

var solid: bool = false
var pathWeight: float = 1.0
var node: Node


func _to_string() -> String:
	return "solid=%s pathWeight=%s node=%s" % [solid, pathWeight, node]
