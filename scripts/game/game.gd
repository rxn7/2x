class_name Game
extends CanvasLayer

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

@onready var grid_container: GridContainer = $Grid/Container
@onready var board: Board = Board.new(self, $TileContainer)
var freeze: bool = false
var score: int = 0: 
	set(value):
		var change: int = value - score
		score = value
		Events.score_changed.emit(value, change)

func _ready() -> void:
	Events.input.connect(on_input)
	board.tile_merged.connect(func(value: int): score += value)

	# Wait for the next frame, grid container items positions are not calculated yet: https://github.com/godotengine/godot/issues/72024
	await get_tree().process_frame
	restart()

func restart() -> void:
	score = 0
	board.restart()
	SoundManager.play_spawn_sound()

func on_input(action: InputAction) -> void:
	if freeze:
		return

	match action:
		InputAction.SlideUp:
			slide_up()
		InputAction.SlideDown:
			slide_down()
		InputAction.SlideLeft:
			slide_left()
		InputAction.SlideRight:
			slide_right()
		InputAction.Restart:
			restart()

func slide(horizontal: bool, reverse: bool) -> void:
	var result: SlideResult = board.slide(horizontal, reverse)

	if result.moved:
		board.spawn_random_tile(true)

		if !board.is_any_move_possible():
			restart()

	if result.merged:
		SoundManager.play_merge_sound()
	elif result.moved:
		SoundManager.play_spawn_sound()

func slide_up(): slide(false, false)
func slide_down(): slide(false, true)
func slide_left(): slide(true, false)
func slide_right(): slide(true, true)