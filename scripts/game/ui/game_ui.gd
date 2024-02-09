extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction
const SCORE_POP_UP_SCENE: PackedScene = preload("res://scenes/score_pop_up.tscn")

@onready var score_label: Label = $Score
@onready var best_score_label: Label = $BestScore
@onready var restart_button: TextureButton = $Restart
@onready var game_over_panel: Control = $GameOver

func _ready():
	game_over_panel.visible = false
	update_best_score(SaveSystem.data.best_score)
	GameEvents.score_changed.connect(update_score)
	GameEvents.best_score_changed.connect(update_best_score)
	GameEvents.game_over.connect(on_game_over)
	GameEvents.game_start.connect(on_game_start)
	restart_button.pressed.connect(func(): GameEvents.input.emit(InputAction.Restart))

func update_score(score: int, change: int) -> void:
	score_label.text = str(score)

	if change < 2:
		return

	var score_pop_up: ScorePopUp = SCORE_POP_UP_SCENE.instantiate()
	score_label.add_child(score_pop_up)
	score_pop_up.set_value(change)

func update_best_score(best_score: int) -> void:
	best_score_label.text = "Best: %d" % best_score

func on_game_over() -> void:
	game_over_panel.visible = true

func on_game_start() -> void:
	game_over_panel.visible = false
