@tool
extends BoxContainer

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
var target_binds : Array[StringName]

func _enter_tree() -> void:
	default_select_music_title = "Select Music..."

	for action in InputMap.get_actions():
		var is_built_in : bool = action.containsn("ui") || action.containsn("spatial_editor")
		if not InputMap.action_get_events(action).is_empty() and not is_built_in:
			target_binds.append(action)

#Input Binding
#func _on_clear_composer_pressed() -> void:
	#RhythmComposer.clear_current_map()
	#music_player.stream = null
	#playback.value = 0
	#paused_pos = 0
	#timer.text = "%02d:%02d" % [0, 0]
#
#func _on_load_map_pressed() -> void:
	#initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_OPEN_FILE, on_confirmed_file_load, "*.json", "Json")
#
#func _on_save_map_pressed() -> void:
	#initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_SAVE_FILE, on_confirmed_file_save, "*.json", "Json")
#
#func _on_record_toggled(toggled_on : bool) -> void:
	#RhythmComposer.is_currently_recording = toggled_on
#
#func _on_select_music_pressed() -> void:
	#initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_OPEN_FILE, on_music_selected, "*.wav, *.mp3, *.ogg", "Audio")
#
#
#func _on_input_value_changed(value : float) -> void:
	#RhythmComposer.set_map_offset(value)
#
#func _on_play_pressed():
	#if music_player.stream:
		#music_player.play(paused_pos)
#
#func _on_pause_pressed():
	#if music_player.stream and music_player.playing:
		#paused_pos = music_player.get_playback_position()
		#music_player.stop()
#
#func _on_stop_pressed():
	#if music_player.stream and music_player.playing:
		#playback.value = 0
		#paused_pos = 0
		#music_player.stop()
# Update

func _process(_delta : float) -> void:
	for action in target_binds:
		if Input.is_action_just_pressed(action):
			RhythmComposer.read_input(action, music_player.get_playback_position())
			return

# Dialog Logic


#func on_confirmed_file_save(file_name : String) -> void:
	#RhythmComposer.save_to_file(file_name)
	#if file_dialog:
		#file_dialog.queue_free()
#
#func on_confirmed_file_load(file_name : String) -> void:
	#RhythmComposer.load_from_file(file_name)
	#var clip = RhythmComposer.get_map_music()
	#music_player.stream = clip
#
	#playback.value = 0
	#paused_pos = 0
	#timer.text = "%02d:%02d" % [0, 0]
	#if file_dialog:
		#file_dialog.queue_free()
#
#func on_music_selected(file_name : String) -> void:
	#RhythmComposer.set_map_music(file_name)
	#music_player.stream = load(file_name)
	#if file_dialog:
		#file_dialog.queue_free()
