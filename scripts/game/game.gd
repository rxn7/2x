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
		if SaveSystem.data.best_score < score:
			SaveSystem.data.best_score = score
			SaveSystem.save_data()
			GameEvents.best_score_changed.emit(score)

		GameEvents.score_changed.emit(value, change)

func _ready() -> void:
	GameEvents.input.connect(on_input)
	board.tile_merged.connect(func(value: int): score += value)

	# Wait for the next frame, grid container items positions are not calculated yet: https://github.com/godotengine/godot/issues/72024
	await get_tree().process_frame
	restart()

func game_over() -> void:
	SoundManager.play(SoundLibrary.GAME_OVER_SOUND)
	GameEvents.game_over.emit()

func restart() -> void:
	freeze = false
	score = 0
	board.restart()
	GameEvents.game_start.emit()

func on_input(action: InputAction) -> void:
	if freeze:
		return

	match action:
		InputAction.SlideUp: slide(false, false)
		InputAction.SlideDown: slide(false, true)
		InputAction.SlideLeft: slide(true, false)
		InputAction.SlideRight: slide(true, true)
		InputAction.Restart: restart()

func slide(horizontal: bool, reverse: bool) -> void:
	var result: SlideResult = board.slide(horizontal, reverse)

	if result.moved or result.merged:
		board.spawn_random_tile(true)
		if !board.is_any_move_possible():
			game_over()
