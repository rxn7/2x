class_name ColorMap
extends Resource

const LOG2: float = 1.0 / log(2.0)

@export var color_map: Dictionary = {
    2: Color.MAGENTA,
    4: Color.MAGENTA,
    8: Color.MAGENTA,
    16: Color.MAGENTA,
    32: Color.MAGENTA,
    64: Color.MAGENTA,
    128: Color.MAGENTA,
    256: Color.MAGENTA,
    512: Color.MAGENTA,
    1024: Color.MAGENTA,
    2048: Color.MAGENTA,
}

func get_color(value: int) -> Color:
	return color_map.get(value, Color.MAGENTA)
