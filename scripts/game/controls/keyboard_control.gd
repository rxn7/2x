extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

func _enter_tree() -> void:
	if OS.has_feature("mobile"):
		queue_free()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_echo() or !event.is_pressed():
			return
			
		if event.keycode == KEY_R:
			GameEvents.input.emit(InputAction.Restart)

		elif event.is_action_pressed("slide_up"):
			GameEvents.input.emit(InputAction.SlideUp)
		elif event.is_action_pressed("slide_down"):
			GameEvents.input.emit(InputAction.SlideDown)
		elif event.is_action_pressed("slide_left"):
			GameEvents.input.emit(InputAction.SlideLeft)
		elif event.is_action_pressed("slide_right"):
			GameEvents.input.emit(InputAction.SlideRight)