@tool
extends BoxContainer

# Main View to Preview Inputs
@onready var main_view : BoxContainer = $MainView
# Buttons
@onready var clear_composer : Button = $"Control/Main Buttons/Clear Composer"
@onready var load_map : Button = $"Control/Main Buttons/Load Map"
@onready var save_map : Button = $"Control/Main Buttons/Save Map"
# Audio
@onready var music_player : AudioStreamPlayer = $MusicPlayer
# Playback bar
@onready var playback : HSlider = $Control/Dashboard/MarginContainer/Contents/Player/HSlider
@onready var timer : Label = $Control/Dashboard/MarginContainer/Contents/Player/Controls/Timer
@onready var select_music : Button = $Control/Dashboard/MarginContainer/Contents/BoxContainer/SelectMusic

var dialog : EditorFileDialog
var default_select_music_title : String
var paused_pos : float

func _enter_tree() -> void:
	default_select_music_title = "Select Music..."

func _input(event : InputEvent) -> void:
	RhythmComposer.read_input(event, music_player.get_playback_position())

#Input Binding
func _on_clear_composer_pressed():
	RhythmComposer.clear_current_map()
	select_music.text = default_select_music_title
	music_player.stream = null
	playback.value = 0
	paused_pos = 0
	timer.text = "%02d:%02d" % [0, 0]

func _on_load_map_pressed():
	initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_OPEN_FILE, on_confirmed_file_load, "*.json", "Json")

func _on_save_map_pressed():
	initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_SAVE_FILE, on_confirmed_file_save, "*.json", "Json")

func _on_record_toggled(toggled_on):
	RhythmComposer.is_currently_recording = toggled_on

func _on_select_music_pressed():
	initialize_file_dialog(EditorFileDialog.FileMode.FILE_MODE_OPEN_FILE, on_music_selected, "*.wav, *.mp3, *.ogg", "Audio")

func _on_play_pressed():
	if music_player.stream:
		music_player.play(paused_pos)

func _on_pause_pressed():
	if music_player.stream and music_player.playing:
		paused_pos = music_player.get_playback_position()
		music_player.stop()

func _on_stop_pressed():
	if music_player.stream and music_player.playing:
		playback.value = 0
		paused_pos = 0
		music_player.stop()
# Update
func _process(_delta : float) -> void:
	if music_player.playing:
		var pos :=  music_player.get_playback_position()
		var minutes = pos / 60
		var seconds = fmod(pos, 60)
		timer.text = "%02d:%02d" % [minutes, seconds]
		playback.value = pos
	else:
		paused_pos = playback.value
	if music_player.stream:
		playback.max_value = music_player.stream.get_length()

# Dialog Logic
func initialize_file_dialog(mode : EditorFileDialog.FileMode, on_file_select : Callable, filter : String = "", filter_name : String = "") -> EditorFileDialog:
	dialog = EditorFileDialog.new()
	dialog.file_mode = mode
	dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	dialog.file_selected.connect(on_file_select)
	dialog.add_filter(filter, filter_name)

	self.add_child(dialog)
	dialog.set_meta("_created_by", self)
	dialog.popup_file_dialog()
	print("opened file dialog")
	return dialog

func on_confirmed_file_save(file_name : String) -> void:
	RhythmComposer.save_to_file(file_name)
	if dialog:
		dialog.queue_free()

func on_confirmed_file_load(file_name : String) -> void:
	RhythmComposer.load_from_file(file_name)
	var clip = RhythmComposer.get_map_music()
	music_player.stream = clip
	select_music.text = RhythmComposer.get_map_music_path()
	playback.value = 0
	paused_pos = 0
	timer.text = "%02d:%02d" % [0, 0]
	if dialog:
		dialog.queue_free()

func on_music_selected(file_name : String) -> void:
	RhythmComposer.set_map_music(file_name)
	select_music.text = file_name
	music_player.stream = load(file_name)
	if dialog:
		dialog.queue_free()
