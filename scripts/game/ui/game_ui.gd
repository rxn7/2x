extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

@onready var score_label: Label = $Score
@onready var restart_button: TextureButton = $Restart

func _ready():
	Events.score_changed.connect(update_score_label)
	restart_button.pressed.connect(func(): Events.input.emit(InputAction.Restart))
	pass

func update_score_label(_score: int) -> void:
	score_label.text = "Score: " + str(_score)
