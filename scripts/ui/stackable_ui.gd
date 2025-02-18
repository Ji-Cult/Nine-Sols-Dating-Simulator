## A user interface with components that stack on 
## top of each other and may be navigated through
class_name StackableUI extends Control

## Emiited when a UI is stacked to the top.
signal ui_stacked(ui: Control)
## Emitted when the top-most UI is popped off.
signal ui_popped(ui: Control)
## Emitted when all UIs in the stack have been popped
signal uis_emptied()

## The managed stack of active child UIs
var ui_stack: Array[Control]

func _ready() -> void:
	for ui in get_children():
		if ui is CanvasItem:
			ui.hidden.connect(check_empty)
	stack(get_child(0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pop()

## Stack a user interface on the top of the stack
func stack(ui: Control) -> void:
	for child_ui in get_children():
		if child_ui != ui:
			child_ui.hide()
	ui.show()
	ui_stack.push_back(ui)
	ui_stacked.emit(ui)

## Pop off the top-most UI in the stack
func pop() -> void:
	if len(ui_stack) <= 1:
		uis_emptied.emit()
	else:
		check_empty()

## Show the topmost UI if one is available
func check_empty() -> void:
	if len(ui_stack) > 1:
		var topmost_ui: Control = ui_stack.pop_back()
		topmost_ui.hide()
		ui_popped.emit(topmost_ui)
		ui_stack.back().show()
