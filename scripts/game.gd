class_name Game
extends CanvasLayer

static var instance: Game

@onready var grid_container: GridContainer = $Background/GridContainer
@onready var tile_container: Node = $Tiles
@onready var score_label: Label = $Score
@onready var restart_button: TextureButton = $Restart
var score: int = 0: set=update_score_label
var board: Board = Board.new()

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	restart_button.connect("pressed", restart)
	# Deferred so Grid Container can be ready first.
	call_deferred("restart")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_echo() or !event.is_pressed():
			return
			
		if event.keycode == KEY_R:
			restart()

		elif event.is_action_pressed("slide_up"):
			slide_up()
		elif event.is_action_pressed("slide_down"):
			slide_down()
		elif event.is_action_pressed("slide_left"):
			slide_left()
		elif event.is_action_pressed("slide_right"):
			slide_right()
		
func restart() -> void:
	score = 0
	board.restart()
	SoundManager.play_spawn_sound()

func slide(horizontal: bool, reverse: bool) -> void:
	var result: SlideResult = board.slide(horizontal, reverse)

	if result.moved:
		board.spawn_random_tile(true)

		if !board.is_any_move_possible():
			restart()

		if result.merged:
			SoundManager.play_merge_sound()
		else:
			SoundManager.play_spawn_sound()

func update_score_label(_score: int) -> void:
	score = _score
	score_label.text = "Score: " + str(score)

func slide_up(): slide(false, false)
func slide_down(): slide(false, true)
func slide_left(): slide(true, false)
func slide_right(): slide(true, true)