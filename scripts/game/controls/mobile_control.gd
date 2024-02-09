extends Node

const InputAction = preload("res://scripts/game/controls/input_action.gd").InputAction

const SWIPE_THRESHOLD: float = 100.0

var swipe_start_position: Vector2
var swiping: bool = false

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if swiping:
			return

		if event.is_pressed():
			swiping = true
			swipe_start_position = event.position

	elif event is InputEventScreenDrag:
		if !swiping:
			return

		var swipe: Vector2 = event.position - swipe_start_position
		if abs(swipe.x) > SWIPE_THRESHOLD:
			swiping = false
			if swipe.x > 0:
				GameEvents.input.emit(InputAction.SlideRight)
			else:
				GameEvents.input.emit(InputAction.SlideLeft)
		elif abs(swipe.y) > SWIPE_THRESHOLD:
			swiping = false
			if swipe.y < 0:
				GameEvents.input.emit(InputAction.SlideUp)
			else:
				GameEvents.input.emit(InputAction.SlideDown)