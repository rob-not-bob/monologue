class_name MainScene
extends Node2D

@onready var tileMap: TileMapAStarGrid = $TileMap
@onready var grid2d: Grid2D = $grid
@onready var indicator: Indicator = $fg_grid_objects/indicator
@onready var hero: Hero = $fg_grid_objects/hero
@onready var villian: Villian = $fg_grid_objects/villain
@onready var ui: UI = $UI

enum CellTypes { Wall, Floor, Quicksand, Pusher, Hero, Villian }
var cellTypeToAtlasCoords: Dictionary = {
	CellTypes.Wall: Vector2i(0, 6),
	CellTypes.Floor: Vector2i(0, 7),
	CellTypes.Quicksand: Vector2i(1, 7),
	CellTypes.Pusher: Vector2i(2, 7),
}

var cellTypeToScene: Dictionary = {
	CellTypes.Quicksand: preload("res://scenes/tiles/quicksand.tscn"),
	CellTypes.Pusher: preload("res://scenes/tiles/pusher.tscn"),
}

var cellTypeToGridTile: Dictionary = {}


func get_tile_pos(pos: Vector2) -> Vector2i:
	var tilePos = tileMap.local_to_map(pos)
	if tilePos.x >= grid2d.gridSize.x:
		tilePos.x = grid2d.gridSize.x - 1
	if tilePos.y >= grid2d.gridSize.y:
		tilePos.y = grid2d.gridSize.y - 1

	return tilePos


func get_local_pos(pos: Vector2) -> Vector2:
	return tileMap.map_to_local(pos)


func get_pos_snapped_to_grid(pos: Vector2):
	return get_local_pos(get_tile_pos(pos))
