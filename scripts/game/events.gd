extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

signal input(action: InputAction)
signal score_changed(score: int)