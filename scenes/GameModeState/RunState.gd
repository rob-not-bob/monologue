extends GameModeState

var hero_moving := true
var path: PackedVector2Array = []
var pathIndex = 0

var playerMovementTween: Tween


func process(_delta: float) -> void:
	if not hero_moving:
		return

	if has_hero_reached_villian():
		Store.redux.dispatch(GameActionsSlice.hero_reached_villian())
		hero_moving = false
		return

	if not path:
		return

	if not playerMovementTween or not playerMovementTween.is_running():
		var delayTurns := 0
		if pathIndex > 0:
			var nextPathPoint = Vector2i(path[pathIndex - 1])
			var tile: GridTile = p.grid2d.get_tile(nextPathPoint.x, nextPathPoint.y)
			delayTurns = tile.delay_turns

		var nextTileLoc = p.get_local_pos(path[pathIndex])
		playerMovementTween = create_tween()
		playerMovementTween.set_ease(Tween.EASE_OUT)
		(
			playerMovementTween
			. tween_property(p.hero, "position", nextTileLoc, 0.5)
			. set_trans(Tween.TRANS_BOUNCE)
			. set_delay(0.25 + delayTurns * 0.75)
		)

		pathIndex += 1


func enter(_msg := {}) -> void:
	var scene_transistion_tween: Tween = p.create_tween()
	scene_transistion_tween.tween_property(p, "scale", Vector2(2, 2), 0.5)
	await scene_transistion_tween.finished
	Store.redux.dispatch(UISlice.set_show_monologue(true))

	path = calculate_path(p.hero.position, p.villian.position)


func has_hero_reached_villian() -> bool:
	return p.get_tile_pos(p.hero.position) == p.get_tile_pos(p.villian.position)


func calculate_path(
	startPos: Vector2i, endPos: Vector2i, snap_to_grid = true
) -> PackedVector2Array:
	var startPoint = p.get_tile_pos(startPos) if snap_to_grid else startPos
	var endPoint = p.get_tile_pos(endPos) if snap_to_grid else endPos
	printt("start, end", startPoint, endPoint)

	var aStarGrid: AStarGrid2D = get_astar_grid_from_grid2d()

	return aStarGrid.get_point_path(startPoint, endPoint)


func get_astar_grid_from_grid2d() -> AStarGrid2D:
	var aStarGrid: AStarGrid2D = AStarGrid2D.new()
	aStarGrid.region = Rect2i(0, 0, p.grid2d.gridSize.x, p.grid2d.gridSize.y)
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStarGrid.update()

	for i in p.grid2d.gridSize.x:
		for j in p.grid2d.gridSize.y:
			var tile: GridTile = p.grid2d.get_tile(i, j)
			var tilePoint = Vector2i(i, j)

			aStarGrid.set_point_solid(tilePoint, tile.solid)
			aStarGrid.set_point_weight_scale(tilePoint, tile.pathWeight)

	return aStarGrid
