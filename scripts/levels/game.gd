extends Control

func _ready() -> void:
	Dialogic.start('test')

func _exit_tree() -> void:
	Dialogic.Save.save()
