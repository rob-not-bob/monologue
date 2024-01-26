extends GameModeState


func process(_delta: float) -> void:
	var mouse_pos: Vector2i = p.get_global_mouse_position() / p.scale
	p.indicator.position = p.get_pos_snapped_to_grid(mouse_pos)

	if Input.is_action_just_pressed("place_tile"):
		place_tile()
	if Input.is_action_just_pressed("erase_tile"):
		erase_tile()

	if Input.is_action_just_pressed("start"):
		state_machine.transition_to("RunState")

	if Input.is_action_just_pressed("select_tile_up"):
		Store.redux.dispatch(BuildSlice.addTileIndex(1))
	if Input.is_action_just_pressed("select_tile_down"):
		Store.redux.dispatch(BuildSlice.addTileIndex(-1))
	if Input.is_action_just_pressed("select_tile_1"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(0))
	if Input.is_action_just_pressed("select_tile_2"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(1))
	if Input.is_action_just_pressed("select_tile_3"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(2))
	if Input.is_action_just_pressed("select_tile_4"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(3))
	if Input.is_action_just_pressed("select_tile_5"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(4))
	if Input.is_action_just_pressed("select_tile_6"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(6))
	if Input.is_action_just_pressed("select_tile_7"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(6))
	if Input.is_action_just_pressed("select_tile_8"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(7))
	if Input.is_action_just_pressed("select_tile_9"):
		Store.redux.dispatch(BuildSlice.selectTileIndex(8))


func enter(_msg := {}) -> void:
	Store.redux.subscribe(_on_active_tile_change, "s.build.tile.activeTile")
	Store.redux.dispatch(BuildSlice.addPlaceableTile(p.CellTypes.Quicksand, 10))
	Store.redux.dispatch(BuildSlice.addPlaceableTile(p.CellTypes.Pusher, 5))
	Store.redux.dispatch(BuildSlice.selectTileIndex(0))

	var tween: Tween = p.create_tween()
	tween.tween_property(p, "scale", Vector2(3, 3), 0.5)
	Store.redux.dispatch(UISlice.hide_overlays())
	p.indicator.show()


func exit() -> void:
	p.indicator.hide()


func _on_active_tile_change(new_tile):
	p.indicator.set_tile(p.cellTypeToScene[new_tile.type], new_tile.num_available)


func set_tile_cell(tilePos: Vector2i, cellType):
	p.tileMap.set_cell(0, tilePos, 0, p.cellTypeToAtlasCoords[cellType])
	p.grid2d.set_tile(tilePos.x, tilePos.y, p.cellTypeToGridTile[cellType])


func place_tile():
	var tile = Store.redux.state().build.tile.activeTile

	if tile.num_available <= 0:
		return

	var tilePos = p.get_tile_pos(p.indicator.position)
	if p.grid2d.get_tile(tilePos.x, tilePos.y).tileType == tile.type:
		return

	if p.get_tile_pos(p.hero.position) == tilePos:
		return
	if p.get_tile_pos(p.villian.position) == tilePos:
		return

	var tileToReplace = get_tile_under_cursor()
	if not can_user_modify_tile(tileToReplace.tileType):
		return

	Store.redux.dispatch(BuildSlice.addNumAvailable(tile.type, -1))

	set_tile_under_cursor(tile.type)


func erase_tile():
	var tileToErase = get_tile_under_cursor()

	if not can_user_erase_tile(tileToErase.tileType):
		return

	Store.redux.dispatch(BuildSlice.addNumAvailable(tileToErase.tileType, 1))

	set_tile_under_cursor(p.CellTypes.Floor)


func get_tile_under_cursor() -> GridTile:
	var indicatorPos = p.get_tile_pos(p.indicator.position)
	return p.grid2d.get_tile(indicatorPos.x, indicatorPos.y)


func set_tile_under_cursor(tileType) -> void:
	var indicatorPos = p.get_tile_pos(p.indicator.position)
	set_tile_cell(indicatorPos, tileType)


func can_user_modify_tile(tileType) -> bool:
	match tileType:
		p.CellTypes.Wall:
			return false
		p.CellTypes.Hero:
			return false
		p.CellTypes.Villian:
			return false
		_:
			return true


func can_user_erase_tile(tileType) -> bool:
	match tileType:
		p.CellTypes.Floor:
			return false
		p.CellTypes.Wall:
			return false
		p.CellTypes.Hero:
			return false
		p.CellTypes.Villian:
			return false
		_:
			return true
