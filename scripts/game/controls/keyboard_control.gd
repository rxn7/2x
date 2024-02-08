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
			Events.input.emit(InputAction.Restart)

		elif event.is_action_pressed("slide_up"):
			Events.input.emit(InputAction.SlideUp)
		elif event.is_action_pressed("slide_down"):
			Events.input.emit(InputAction.SlideDown)
		elif event.is_action_pressed("slide_left"):
			Events.input.emit(InputAction.SlideLeft)
		elif event.is_action_pressed("slide_right"):
			Events.input.emit(InputAction.SlideRight)