class_name Tile
extends Panel

const APPEAR_ANIMATION_TIME: float = 0.2
const DOUBLE_ANIMATION_TIME: float = 0.1
const MOVE_ANIMATION_TIME: float = 0.1
const MERGE_PARTICLES_SCENE: PackedScene = preload("res://scenes/merge_particles.tscn")
const COLOR_MAP: ColorMap = preload("res://resources/color_map.tres")
const SPAWN_SOUND: AudioStream = preload("res://assets/audio/spawn_tile.wav") 
const MERGE_SOUNDS: Array[AudioStream] = [preload("res://assets/audio/merge.wav"), preload("res://assets/audio/merge2.ogg")]

@onready var label = $Label

var position_tween: Tween
var value: int = 0: set = _set_value
var target_position: Vector2

func pop_up(wait_for_move_animation: bool = true) -> void:
	SoundManager.play(Sound.new(SPAWN_SOUND, randf_range(0.9, 1.1)))

	scale = Vector2.ZERO
	self_modulate.a = 0.0

	var tween: Tween = create_tween()

	if wait_for_move_animation:
		tween.tween_interval(MOVE_ANIMATION_TIME)

	tween.tween_property(self, "scale", Vector2.ONE, APPEAR_ANIMATION_TIME).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "self_modulate:a", 1.0, APPEAR_ANIMATION_TIME).set_trans(Tween.TRANS_BACK)

func double() -> void:
	value *= 2

	SoundManager.play(Sound.new(MERGE_SOUNDS.pick_random(), randf_range(0.7, 1.3)))
	spawn_merge_particles()
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2.ONE * 1.1, DOUBLE_ANIMATION_TIME)
	tween.tween_property(self, "scale", Vector2.ONE, DOUBLE_ANIMATION_TIME)

func update_position(idx: int) -> void:
	var grid_cell: Control = Game.instance.grid_container.get_child(idx)
	target_position = grid_cell.global_position - Vector2.ONE
	
	var just_appeared: bool = value == 0
	if just_appeared:
		position = target_position
	else:
		if position_tween:
			position_tween.kill()

		position_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		position_tween.tween_property(self, "position", target_position, MOVE_ANIMATION_TIME)

func _set_value(new_value: int) -> void:
	value = new_value
	label.text = str(value)
	self_modulate = COLOR_MAP.get_color(value)

func spawn_merge_particles() -> void:
	var particles: GPUParticles2D = MERGE_PARTICLES_SCENE.instantiate()
	Game.instance.add_child(particles)
	particles.self_modulate = self_modulate
	particles.amount = value
	particles.global_position = target_position + pivot_offset
	particles.emitting = true
	particles.connect("finished", func(): particles.queue_free())
