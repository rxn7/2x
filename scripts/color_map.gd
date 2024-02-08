class_name ColorMap
extends Resource

const LOG2: float = 1.0 / log(2.0)

@export var color_map: Dictionary

func get_color(value: int) -> Color:
	return color_map.get(value, Color.MAGENTA)
