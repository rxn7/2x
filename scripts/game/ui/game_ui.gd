extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction
const SCORE_POP_UP_SCENE: PackedScene = preload("res://scenes/score_pop_up.tscn")

@onready var score_label: Label = $Score
@onready var restart_button: TextureButton = $Restart
@onready var game_over_panel: Control = $GameOver

func _ready():
	game_over_panel.visible = false
	GameEvents.score_changed.connect(on_score_changed)
	GameEvents.game_over.connect(on_game_over)
	GameEvents.game_start.connect(on_game_start)
	restart_button.pressed.connect(func(): GameEvents.input.emit(InputAction.Restart))

func on_score_changed(score: int, change: int) -> void:
	score_label.text = str(score)

	if change < 2:
		return

	var score_pop_up: ScorePopUp = SCORE_POP_UP_SCENE.instantiate()
	score_label.add_child(score_pop_up)
	score_pop_up.set_value(change)

func on_game_over() -> void:
	game_over_panel.visible = true

func on_game_start() -> void:
	game_over_panel.visible = false
