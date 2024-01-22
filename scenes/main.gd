extends Node2D

@onready var tileMap: TileMapAStarGrid = $TileMap
@onready var grid2d: Grid2D = $grid
@onready var indicator: Indicator = $fg_grid_objects/indicator;
@onready var hero: Hero = $fg_grid_objects/hero;
@onready var villian: Villian = $fg_grid_objects/villain;

enum CellTypes { Wall, Floor, Quicksand, Pusher, Hero, Villian }
var cellTypeToAtlasCoords: Dictionary = {
	CellTypes.Wall: Vector2i(0, 6),
	CellTypes.Floor: Vector2i(0, 7),
	CellTypes.Quicksand: Vector2i(1, 7),
	CellTypes.Pusher: Vector2i(2, 7),
}

var cellTypeToGridTile: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	hero.ready.connect(func():
		hero.position = get_pos_snapped_to_grid(hero.position)
	)
	villian.ready.connect(func():
		villian.position = get_pos_snapped_to_grid(villian.position)
	)
	create_grid_tiles()
	create_grid_from_tilemap()


func _process(_delta) -> void:
	var mouse_pos: Vector2i = get_global_mouse_position() / scale
	indicator.position = get_pos_snapped_to_grid(mouse_pos)

	if Input.is_action_just_pressed("place_tile"):
		var tilePos = tileMap.local_to_map(indicator.position)
		set_tile_cell(tilePos, CellTypes.Quicksand)
		var path := calculate_path(hero.position, villian.position)
		for point in path:
			tileMap.set_cell(0, point, 0, cellTypeToAtlasCoords[CellTypes.Pusher])
	if Input.is_action_just_pressed("calc_path"):
		var path := calculate_path(hero.position, villian.position)
		printt('path', path)
		for point in path:
			tileMap.set_cell(0, point, 0, cellTypeToAtlasCoords[CellTypes.Pusher])



func set_tile_cell(tilePos: Vector2i, cellType: CellTypes):
	tileMap.set_cell(0, tilePos, 0, cellTypeToAtlasCoords[cellType])
	grid2d.set_tile(tilePos.x, tilePos.y, cellTypeToGridTile[cellType])


func create_grid_tiles() -> void:
	var createGridTile = func(solid: bool, weight: float) -> GridTile:
		var tile := GridTile.new()
		tile.solid = solid
		tile.pathWeight = weight
		return tile

	cellTypeToGridTile[CellTypes.Wall] = createGridTile.call(true, 99999.0)
	cellTypeToGridTile[CellTypes.Quicksand] = createGridTile.call(false, 3.0)
	cellTypeToGridTile[CellTypes.Pusher] = createGridTile.call(false, 2.0)
	cellTypeToGridTile[CellTypes.Floor] = createGridTile.call(false, 1.0)


func create_grid_from_tilemap():
	grid2d.cellSize = tileMap.tile_set.tile_size
	grid2d.init_grid(func(): return cellTypeToGridTile[CellTypes.Floor])

	var set_grid_tiles_by_cell_type = func(cellType: CellTypes):
		var tiles: Array[Vector2i] = tileMap.get_used_cells_by_id(
			0, 0, cellTypeToAtlasCoords[cellType]
		)
		for tile in tiles:
			grid2d.set_tile(tile.x, tile.y, cellTypeToGridTile[cellType])
		

	set_grid_tiles_by_cell_type.call(CellTypes.Wall)
	set_grid_tiles_by_cell_type.call(CellTypes.Quicksand)

	print("grid", grid2d.grid)


func calculate_path(startPos: Vector2i, endPos: Vector2i, snap_to_grid=true) -> PackedVector2Array:
	var startPoint = get_tile_pos(startPos) if snap_to_grid else startPos
	var endPoint = get_tile_pos(endPos) if snap_to_grid else endPos
	printt('start, end', startPoint, endPoint)

	var aStarGrid: AStarGrid2D = get_astar_grid_from_grid2d()
	
	return aStarGrid.get_point_path(startPoint, endPoint)


func get_astar_grid_from_grid2d() -> AStarGrid2D:
	var aStarGrid: AStarGrid2D = AStarGrid2D.new()
	aStarGrid.region = Rect2i(0, 0, grid2d.gridSize.x, grid2d.gridSize.y)
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStarGrid.update()

	for i in grid2d.gridSize.x:
		for j in grid2d.gridSize.y:
			var tile: GridTile = grid2d.get_tile(i, j)
			var tilePoint = Vector2i(i, j)

			aStarGrid.set_point_solid(tilePoint, tile.solid)
			aStarGrid.set_point_weight_scale(tilePoint, tile.pathWeight)

	return aStarGrid


func get_tile_pos(pos: Vector2) -> Vector2i:
	return tileMap.local_to_map(pos)


func get_pos_snapped_to_grid(pos: Vector2):
	return tileMap.map_to_local(get_tile_pos(pos))

