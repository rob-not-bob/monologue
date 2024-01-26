class_name GameActionsSlice
extends Node


static func reducer(_state: Dictionary, action: Redux.Action) -> Dictionary:
	match action.type:
		"HERO_REACHED_VILLIAN":
			return {
				"has_hero_reached_villian": true,
			}
		"RESET":
			return {
				"has_hero_reached_villian": false,
			}

	return {}


static var slice: Redux.Slice = (
	Redux
	. Slice
	. new(
		"gameActions",
		{
			"has_hero_reached_villian": false,
		},
	)
)


static func hero_reached_villian() -> Redux.Action:
	return slice.create_action("HERO_REACHED_VILLIAN")


func _ready() -> void:
	slice.set_reducer(reducer)

	Store.redux.add_slice(slice)
