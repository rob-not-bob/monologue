class_name TileMapAStarGrid
extends TileMap

@export_category("TileMap Info")
@export var gridSize: Vector2i = Vector2.ZERO
@export var obstacleAtlasSourceIndex: int = 0
@export var weightDataLayerName: String = "weight"

# @export var aStarMode: AStarGrid2D.Diagonal_Mode = AStarGrid2D.DIAGONAL_MODE_NEVER

var solidAtlasCoords: Array[Vector2i] = []
var obstacleAtlasCoords: Array[Vector2i] = []
var aStarGrid: AStarGrid2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	compute_grid()


func compute_grid():
	aStarGrid = AStarGrid2D.new()
	aStarGrid.region = Rect2i(0, 0, gridSize.x, gridSize.y)
	aStarGrid.cell_size = tile_set.tile_size
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStarGrid.update()

	add_all_solids()
	add_all_obstacles()


func compute_path(startPos: Vector2, endPos: Vector2, use_local_to_map = true) -> Array[Vector2i]:
	var startPoint = startPos
	var endPoint = endPos
	if use_local_to_map:
		startPoint = local_to_map(startPos)
		endPoint = local_to_map(endPos)

	return aStarGrid.get_id_path(startPoint, endPoint)


func add_all_solids() -> void:
	for cell in solidAtlasCoords:
		var obstacles = get_used_cells_by_id(0, 0, cell)
		for point in obstacles:
			aStarGrid.set_point_solid(point)


func add_all_obstacles() -> void:
	for cell in obstacleAtlasCoords:
		var obstacles = get_used_cells_by_id(0, 0, cell)
		for point in obstacles:
			aStarGrid.set_point_weight_scale(point, get_weight_data(cell))


func get_weight_data(cellAtlasCoords: Vector2i) -> float:
	var tileSetAtlasSource: TileSetAtlasSource = tile_set.get_source(obstacleAtlasSourceIndex)
	var tileData: TileData = tileSetAtlasSource.get_tile_data(cellAtlasCoords, 0)

	return tileData.get_custom_data(weightDataLayerName)
