extends GameModeState

func enter(_msg := {}) -> void:
	p.hero.ready.connect(func():
		p.hero.position = p.get_pos_snapped_to_grid(p.hero.position)
	)
	p.villian.ready.connect(func():
		p.villian.position = p.get_pos_snapped_to_grid(p.villian.position)
	)
	create_grid_tiles()
	create_grid_from_tilemap()

	state_machine.transition_to("BuildState")


func create_grid_tiles() -> void:
	var createGridTile = func(solid: bool, weight: float, delay_turns = 0, num_available = 99) -> GridTile:
		var tile := GridTile.new()
		tile.solid = solid
		tile.pathWeight = weight
		tile.delay_turns = delay_turns
		tile.num_available = num_available
		return tile

	p.cellTypeToGridTile[p.CellTypes.Wall] = createGridTile.call(true, 99999.0, 0, 0)
	p.cellTypeToGridTile[p.CellTypes.Quicksand] = createGridTile.call(false, 3.0, 2, 10)
	p.cellTypeToGridTile[p.CellTypes.Pusher] = createGridTile.call(false, 2.0, 0, 5)
	p.cellTypeToGridTile[p.CellTypes.Floor] = createGridTile.call(false, 1.0, 0, 0)


func create_grid_from_tilemap():
	p.grid2d.cellSize = p.tileMap.tile_set.tile_size
	p.grid2d.init_grid(func(): return p.cellTypeToGridTile[p.CellTypes.Floor])

	var set_grid_tiles_by_cell_type = func(cellType):
		var tiles: Array[Vector2i] = p.tileMap.get_used_cells_by_id(
			0, 0, p.cellTypeToAtlasCoords[cellType]
		)
		for tile in tiles:
			p.grid2d.set_tile(tile.x, tile.y, p.cellTypeToGridTile[cellType])
		

	set_grid_tiles_by_cell_type.call(p.CellTypes.Wall)
	set_grid_tiles_by_cell_type.call(p.CellTypes.Quicksand)


