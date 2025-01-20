extends Node

const LEVELS_PATH: String = "res://scenes/levels"

var levels: Dictionary = {}

func _ready() -> void:
	for file_name in DirAccess.get_files_at(LEVELS_PATH):
		var path: String = "%s/%s" % [LEVELS_PATH, file_name]
		var scene: PackedScene = load(path)
		levels[file_name.get_basename()] = scene

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
