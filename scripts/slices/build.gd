class_name BuildSlice
extends Node


static func setTileIndex(state: Dictionary, index: int, wrapIndex = true) -> int:
	var numPlaceableTiles = state.tile.placeableTiles.size()
	if wrapIndex:
		return index % numPlaceableTiles
	elif index >= numPlaceableTiles:
		return state.tile.activeIndex
	else:
		return index


static func reducer(s: Dictionary, action: Redux.Action) -> Dictionary:
	match action.type:
		"ADD_TILE_INDEX":
			var activeIndex = setTileIndex(s, s.tile.activeIndex + action.d.amount)
			return {
				"tile":
				{
					"activeTile": s.tile.placeableTiles[activeIndex],
					"activeIndex": activeIndex,
				}
			}
		"SELECT_TILE_INDEX":
			var activeIndex = setTileIndex(s, action.d.index, false)

			return {
				"tile":
				{
					"activeTile": s.tile.placeableTiles[activeIndex],
					"activeIndex": activeIndex,
				}
			}
		"ADD_NUM_AVAILABLE":
			var type = action.d.type
			var addAmount = action.d.add_amount
			for tile in s.tile.placeableTiles:
				if tile.type == type:
					tile.num_available += addAmount

			return {
				"tile":
				{
					"activeTile": s.tile.placeableTiles[s.tile.activeIndex],
					"placeableTiles": s.tile.placeableTiles
				}
			}
		"ADD_PLACABLE_TILE":
			s.tile.placeableTiles.append(action.d.tile)

			return Redux.c("tile.placeableTiles", s.tile.placeableTiles)

	return {}


func sagas(action: Redux.Action) -> Redux.Action:
	match action.type:
		"QUIT_GAME":
			pass

	return action


static var slice: Redux.Slice = (
	Redux
	. Slice
	. new(
		"build",
		{
			"tile":
			{
				"activeIndex": 0,
				"activeTile": {},
				"placeableTiles": [],
			}
		},
	)
)


# Is this one needed? Seems redundant with placeTile
static func setTileCell(tilePos: Vector2i) -> Redux.Action:
	return slice.create_action("SET_TILE_CELL", {"x": tilePos.x, "y": tilePos.y})


static func addTileIndex(addAmount: int) -> Redux.Action:
	return slice.create_action("ADD_TILE_INDEX", {"amount": addAmount})


static func selectTileIndex(index: int) -> Redux.Action:
	return slice.create_action("SELECT_TILE_INDEX", {"index": index})


static func addPlaceableTile(type, numTiles: int) -> Redux.Action:
	return slice.create_action(
		"ADD_PLACABLE_TILE", {"tile": {"type": type, "num_available": numTiles}}
	)


static func addNumAvailable(type, addAmount: int) -> Redux.Action:
	return slice.create_action("ADD_NUM_AVAILABLE", {"type": type, "add_amount": addAmount})


func _ready() -> void:
	slice.set_reducer(reducer)
	slice.add_saga(sagas)

	Store.redux.add_slice(slice)
