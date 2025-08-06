@tool
class_name EditorWindow extends BoxContainer

# Tabs
@export_group("Toolbar")
@export var file_tab : PopupMenu
@export var edit_tab : PopupMenu
@export var input_recorder : TextureButton
@export var playtest : TextureButton

# Audio
@export_group("Audio")
@export var music_player : AudioStreamPlayer

@export_group("Playbar Bar")
@export var playback : HSlider
@export var timer : Label

@export_group("New File Wizard")
@export var new_file_wizard : PackedScene

var file_dialog : EditorFileDialog
var wizard_dialog : Popup

var default_select_music_title : String
var paused_pos : float
var target_binds : Array[Dictionary]

func _enter_tree() -> void:
	default_select_music_title = "Select Music..."

	var proj_settings := ProjectSettings.get_property_list()
	for entry in proj_settings:
		var name : StringName = entry.name
		var is_input := name.containsn("input/") && !name.containsn("ui")
		if is_input:
			var event = ProjectSettings.get_setting(name)
			print("%s: %s" % [name, event])
			target_binds.append({name.split("/")[1] : event})



func get_events(entry_bind : Dictionary) -> Array[InputEventKey]:
	var result : Array[InputEventKey]
	for entry in entry_bind["events"]:
		var event : InputEventKey = entry
		result.append(event)
	return result

func _unhandled_input(event : InputEvent) -> void:
	if !music_player || !music_player.stream || event is InputEventMouse || not event.is_pressed():
		return

	for entry in target_binds:
		var value = entry.values()[0]
		var key = entry.keys()[0]
		var is_valid := get_events(value)[0].is_match(event)
		if is_valid:
			print(key)
			RhythmComposer.read_input(key,music_player.get_playback_position())
			return
