## Full screen blanker for transitioning between scenes
class_name Fader extends BaseUI

## Controls the fade in and fade out animations
@onready var animator: AnimationPlayer = $animator

func open() -> void:
	super.open()
	animator.play("open")

func close() -> void:
	animator.play("close")
	await animator.animation_finished
	super.close()
