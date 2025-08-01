@tool
extends Control

var file_dialog : EditorFileDialog
var setup_wizard : Window

func create_file_dialog(mode : EditorFileDialog.FileMode, on_file_select : Callable, filter : String = "", filter_name : String = "") -> EditorFileDialog:
	file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = mode
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.file_selected.connect(on_file_select)
	file_dialog.file_selected.connect(func(_path : String) -> void: clear_file_dialog())
	file_dialog.add_filter(filter, filter_name)

	self.add_child(file_dialog)
	file_dialog.set_meta("_created_by", self)
	file_dialog.popup_file_dialog()
	print("opened file dialog")
	return file_dialog

func create_setup_wizard( body : Control, title : String,) -> Window:
	setup_wizard = Window.new()
	setup_wizard.add_child(body)

	setup_wizard.close_requested.connect(clear_setup_wizard)
	setup_wizard.title = title
	setup_wizard.popup_window = true
	setup_wizard.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	setup_wizard.min_size = Vector2i(300,250)

	self.add_child(setup_wizard)
	print("Setup Wizard initiated")
	return setup_wizard

func clear_setup_wizard() -> void:
	if setup_wizard:
		setup_wizard.queue_free()

func clear_file_dialog() -> void:
	if file_dialog:
		file_dialog.queue_free()
