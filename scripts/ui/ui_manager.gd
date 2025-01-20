extends Control

const UIS_PATH: String = "res://scenes/ui"

@onready var gui: CanvasLayer = $gui

var uis: Dictionary = {}

var active_uis: Array:
	get:
		return instanced_uis.values().filter(func(ui): return ui.visible)

var inactive_uis: Array:
	get:
		return instanced_uis.values().filter(func(ui): return not ui.visible)
	
var instanced_uis: Dictionary:
	get:
		var dict: Dictionary = {}
		for ui in gui.get_children():
			if ui is BaseUI:
				dict[ui.name] = ui
		return dict

var current_ui: BaseUI:
	get:
		if len(active_uis) <= 0:
			return null
		return active_uis[-1]

func _ready() -> void:
	for file_name in DirAccess.get_files_at(UIS_PATH):
		var path: String = "%s/%s" % [UIS_PATH, file_name]
		var scene: PackedScene = load(path)
		uis[file_name.get_basename()] = scene

func open_ui(ui_name: String, re_instance: bool = false) -> BaseUI:
	var ui: BaseUI = null
	if re_instance:
		free_ui(ui_name)
		ui = instance_ui(ui_name)
	else:
		ui = get_ui(ui_name)
	current_ui = ui
	ui.open()
	return ui

func close_ui(ui_name: String, free: bool = false) -> BaseUI:
	if not uis.has(ui_name):
		return null
	var ui: BaseUI = instanced_uis[ui_name]
	ui.close()
	if free:
		free_ui(ui_name)
		return null
	return ui

func get_ui(ui_name: String) -> BaseUI:
	if not uis.has(ui_name):
		return null
	if not instanced_uis.has(ui_name) or instanced_uis[ui_name] == null:
		instance_ui(ui_name)
	if not is_instance_valid(instanced_uis[ui_name]):
		return null
	var ui: BaseUI = instanced_uis[ui_name]
	return ui

func instance_ui(ui_name: String, start_open = false) -> BaseUI:
	if not uis.has(ui_name):
		return null
	var instanced_ui: BaseUI = uis[ui_name].instantiate()
	instanced_ui.name = ui_name
	gui.add_child(instanced_ui)
	if not start_open:
		instanced_ui.hide()
	return instanced_ui

func free_ui(ui_name: String) -> void:
	if not uis.has(ui_name):
		return
	var ui: BaseUI = instanced_uis[ui_name]
	if ui == null: return
	ui.queue_free()
