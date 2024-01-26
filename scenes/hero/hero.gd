class_name Hero
extends Sprite2D


func _ready():
	if G.hero:
		return
	G.hero = self
	G.hero_spawn.emit()
