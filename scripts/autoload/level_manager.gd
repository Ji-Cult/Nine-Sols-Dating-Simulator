extends Node

const LEVELS_PATH: String = "res://scenes/levels"

var levels: Dictionary = {
	"game": preload("res://scenes/levels/game.tscn"),
	"main_menu": preload("res://scenes/levels/main_menu.tscn"),
}

func change_level(level_name: String) -> void:
	var fader: Fader = UIManager.open_ui("fader")
	var fader_animator: AnimationPlayer = fader.get_node("animator")
	await fader_animator.animation_finished
	if not levels.has(level_name):
		printerr("Level name ", level_name, " does not exist!")
	if get_tree().change_scene_to_packed(levels[level_name]) != OK:
		printerr("Failed to change level to ", level_name)
	UIManager.close_ui("fader")
	await fader_animator.animation_finished
