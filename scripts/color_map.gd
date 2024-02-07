class_name ColorMap
extends Resource

const LOG2: float = 1.0 / log(2.0)

@export var color_map: Array[Color]

func get_color(value: int) -> Color:
	var index: int = log(value) * LOG2- 1
	
	if index < 0 or index >= color_map.size():
		return Color.MAGENTA
	
	return color_map[index]
