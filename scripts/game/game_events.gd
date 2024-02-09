extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

signal input(action: InputAction)
signal score_changed(score: int, change: int)
signal best_score_changed(best_score: int)
signal game_over
signal game_start