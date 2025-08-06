@tool
class_name RhythmLevelEditor extends EditorPlugin

const MAIN_PANEL = preload("res://addons/rhythm_level_editor/editor_window.tscn")
const COMPOSER = "RhythmComposer"
const FILE_DIALOG = "ExtendedWindows"

var ins
func _enter_tree():
	ins = MAIN_PANEL.instantiate()
	EditorInterface.get_editor_main_screen().add_child(ins)
	ins.hide()

	add_autoload_singleton(COMPOSER, "res://addons/rhythm_level_editor/scripts/map_composer.gd")
	add_autoload_singleton(FILE_DIALOG, "res://addons/rhythm_level_editor/scripts/dialog_manager.gd")

func _exit_tree():
	EditorInterface.get_editor_main_screen().remove_child(ins)
	ins.queue_free()

	remove_autoload_singleton(COMPOSER)
	remove_autoload_singleton(FILE_DIALOG)

func _has_main_screen():
	return true

func _make_visible(visible):
	if ins:
		ins.visible = visible

func _get_plugin_name():
	return "Rhythm Composer"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
