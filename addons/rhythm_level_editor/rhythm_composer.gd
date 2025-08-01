@tool
extends BoxContainer
# Main View to Preview Inputs
@onready var main_view : BoxContainer = $MainView
# Buttons
@onready var clear_composer : Button = $"Control/Main Buttons/Clear Composer"
@onready var load_map : Button = $"Control/Main Buttons/Load Map"
@onready var save_map : Button = $"Control/Main Buttons/Save Map"


var dialog : EditorFileDialog

func _on_clear_composer_pressed():
	pass # Replace with function body.


func _on_load_map_pressed():
	pass # Replace with function body.


func _on_save_map_pressed():
	var file_dialog := initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_SAVE_FILE)


func initialize_file_dialog(mode : EditorFileDialog.FileMode) -> EditorFileDialog:
	dialog = EditorFileDialog.new()
	dialog.file_mode = mode
	dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	dialog.file_selected.connect(on_confirmed_file_save)
	dialog.add_filter("*.json", "Json")

	self.add_child(dialog)
	dialog.set_meta("_created_by", self)
	dialog.popup_file_dialog()

	return dialog

func on_confirmed_file_save(file_name : String) -> void:
	print(file_name)
	if dialog:
		dialog.queue_free()
