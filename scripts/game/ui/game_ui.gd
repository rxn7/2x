extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction
const SCORE_POP_UP_SCENE: PackedScene = preload("res://scenes/score_pop_up.tscn")

@onready var score_label: Label = $Score
@onready var restart_button: TextureButton = $Restart

func _ready():
	Events.score_changed.connect(on_score_changed)
	restart_button.pressed.connect(func(): Events.input.emit(InputAction.Restart))

func on_score_changed(score: int, change: int) -> void:
	if change < 2:
		return

	score_label.text = str(score)
	var score_pop_up: ScorePopUp = SCORE_POP_UP_SCENE.instantiate()
	score_label.add_child(score_pop_up)
	score_pop_up.set_value(change)