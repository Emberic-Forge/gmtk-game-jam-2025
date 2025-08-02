@tool
class_name BPMSettings extends PanelContainer

@export var input : SpinBox
@export var confirm : Button
@export var cancel : Button

signal on_confim(value : int)
signal on_cancel

var value : int

func _on_input_value_changed(value : int) -> void:
	self.value = value

func _on_confirm_pressed() -> void:
	on_confim.emit(value)

func _on_cancel_pressed() -> void:
	on_cancel.emit()
