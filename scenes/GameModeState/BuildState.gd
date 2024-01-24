extends GameModeState

var activeTileIndex = 0
var player_tiles = [p.CellTypes.Quicksand, p.CellTypes.Pusher]


func process(_delta: float) -> void:
	var mouse_pos: Vector2i = p.get_global_mouse_position() / p.scale
	p.indicator.position = p.get_pos_snapped_to_grid(mouse_pos)

	if Input.is_action_just_pressed("place_tile"):
		place_tile()

	if Input.is_action_just_pressed("start"):
		state_machine.transition_to("RunState")

	if Input.is_action_just_pressed("select_tile_up"):
		add_tile_index(1)
	if Input.is_action_just_pressed("select_tile_down"):
		add_tile_index(-1)
	if Input.is_action_just_pressed("select_tile_1"):
		select_tile_index(0)
	if Input.is_action_just_pressed("select_tile_2"):
		select_tile_index(1)
	if Input.is_action_just_pressed("select_tile_3"):
		select_tile_index(2)
	if Input.is_action_just_pressed("select_tile_4"):
		select_tile_index(3)
	if Input.is_action_just_pressed("select_tile_5"):
		select_tile_index(4)
	if Input.is_action_just_pressed("select_tile_6"):
		select_tile_index(5)
	if Input.is_action_just_pressed("select_tile_7"):
		select_tile_index(6)
	if Input.is_action_just_pressed("select_tile_8"):
		select_tile_index(7)
	if Input.is_action_just_pressed("select_tile_9"):
		select_tile_index(8)


func enter(_msg := {}) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var tween: Tween = p.create_tween()
	tween.tween_property(p, "scale", Vector2(3, 3), 0.5)
	p.ui.hide()
	select_tile_index(activeTileIndex)
	p.indicator.show()


func exit() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	p.indicator.hide()


func set_tile_cell(tilePos: Vector2i, cellType):
	p.tileMap.set_cell(0, tilePos, 0, p.cellTypeToAtlasCoords[cellType])
	p.grid2d.set_tile(tilePos.x, tilePos.y, p.cellTypeToGridTile[cellType])


func add_tile_index(add_amount: int):
	activeTileIndex = (activeTileIndex + add_amount) % player_tiles.size()
	select_tile_index(activeTileIndex)


func select_tile_index(index: int):
	if index - 1 > player_tiles.size():
		return

	activeTileIndex = index
	var tileType = player_tiles[activeTileIndex]

	p.indicator.set_tile(p.cellTypeToScene[tileType], p.cellTypeToGridTile[tileType].num_available)


func place_tile():
	var tileType = player_tiles[activeTileIndex]
	var tile = p.cellTypeToGridTile[tileType]

	if tile.num_available <= 0:
		return

	var tilePos = p.get_tile_pos(p.indicator.position)
	if p.grid2d.get_tile(tilePos.x, tilePos.y) == tile:
		return

	if p.get_tile_pos(p.hero.position) == tilePos:
		return
	if p.get_tile_pos(p.villian.position) == tilePos:
		return

	p.cellTypeToGridTile[tileType].num_available -= 1
	p.indicator.set_num_tiles(p.cellTypeToGridTile[tileType].num_available)

	set_tile_cell(tilePos, tileType)