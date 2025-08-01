@tool
extends EditorPlugin

const MainPanel = preload("res://addons/rhythm_level_editor/rhythm_composer.tscn")

var ins
func _enter_tree():
	ins = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(ins)
	ins.hide()


func _exit_tree():
	if ins:
		EditorInterface.get_editor_main_screen().remove_child(ins)
		ins.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if ins:
		ins.visible = visible


func _get_plugin_name():
	return "Rhythm Composer"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
