class_name ScorePopUp
extends Label

const TARGET_DISTANCE_TRAVEL_MIN: float = 60.0
const TARGET_DISTANCE_TRAVEL_MAX: float = 100.0
const POSITION_ANIMATION_DURATION: float = 0.5
const ALPHA_ANIMATION_DURATION: float = 0.2

func _ready() -> void:
	var angle = randf_range(0, PI * 2)
	var target_position: Vector2 = position + Vector2.UP.rotated(angle) * randf_range(TARGET_DISTANCE_TRAVEL_MIN, TARGET_DISTANCE_TRAVEL_MAX)

	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "self_modulate:a", 0.0, ALPHA_ANIMATION_DURATION).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN).set_delay(POSITION_ANIMATION_DURATION - ALPHA_ANIMATION_DURATION)

func set_value(value: int) -> void:
	self_modulate = Tile.COLOR_MAP.get_color(value)
	text = "+%d" % value
