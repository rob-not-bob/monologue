class_name Grid2D
extends RefCounted

var gridSize: Vector2i = Vector2i.ZERO
var cellSize: Vector2i = Vector2i(16, 16)

var grid: Array


func _init(_gridSize: Vector2i, _cellSize: Vector2i = Vector2i(16, 16)) -> void:
	gridSize = _gridSize
	cellSize = _cellSize


func init_grid(create_grid_tile: Callable) -> Array:
	grid = []
	for i in gridSize.x:
		var gridRow: Array = []
		for j in gridSize.y:
			if create_grid_tile:
				gridRow.append(create_grid_tile.call())
			else:
				gridRow.append(null)
		grid.append(gridRow)

	return grid


func get_tile(x: int, y: int):
	if is_outside_grid_bounds(x,y):
		return null

	return grid[x][y]


func set_tile(x: int, y: int, tile) -> void:
	if is_outside_grid_bounds(x, y):
		return
	grid[x][y] = tile


func is_outside_grid_bounds(x: int, y: int) -> bool:
	return x < 0 or y < 0 or x >= gridSize.x or y >= gridSize.y


func local_to_grid(localPos: Vector2) -> Vector2i:
	return Vector2i(
		(int) (localPos.x / gridSize.x),
		(int) (localPos.y / gridSize.y)
	)


func grid_to_local(gridPos: Vector2i) -> Vector2:
	return Vector2(
		(gridPos.x * gridSize.x),
		(gridPos.y * gridSize.y)
	)

