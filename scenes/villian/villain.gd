class_name Villian
extends Sprite2D


func _ready():
	if G.villian:
		return
	G.villian = self
	G.villian_spawn.emit()
