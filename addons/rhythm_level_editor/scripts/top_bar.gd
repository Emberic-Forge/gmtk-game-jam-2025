@tool
extends PanelContainer

@export var bpm_menu : PackedScene
@export var debug_preview : Control


func _on_file_id_pressed(entry_id : int) -> void:
	match entry_id:
		0:
			create_new_file()
		1:
			load_map()
		2:
			save_map()

func _on_edit_id_pressed(entry_id : int) -> void:
	match entry_id:
		0:
			rename_map()
		1:
			change_music()
		2:
			change_bpm()

func create_new_file() -> void:
	print("creating new file")
	ExtendedWindows.create_file_dialog(EditorFileDialog.FILE_MODE_SAVE_FILE, on_saving_new_file, "*.json", "Json")
	pass

func load_map() -> void:
	print("loading file")
	ExtendedWindows.create_file_dialog(EditorFileDialog.FILE_MODE_OPEN_FILE, on_file_loaded, "*.json", "Json")
	pass

func save_map() -> void:
	print("saving file")
	ExtendedWindows.create_file_dialog(EditorFileDialog.FILE_MODE_SAVE_FILE, on_file_saved, "*.json", "Json")
	pass

func rename_map() -> void:
	pass

func change_music() -> void:
	ExtendedWindows.create_file_dialog(EditorFileDialog.FILE_MODE_OPEN_FILE, on_new_music_selected, "*.wav, *.mp3, *.ogg", "Audio")
	pass

func change_bpm() -> void:
	var settings : BPMSettings = bpm_menu.instantiate()
	settings.input.set_value_no_signal(RhythmComposer.get_map_bpm())
	settings.on_cancel.connect(func() -> void: ExtendedWindows.clear_setup_wizard())
	settings.on_confim.connect(func(new_value : int) -> void:
		ExtendedWindows.clear_setup_wizard()
		RhythmComposer.set_map_bpm(new_value)
		print("Applied new bpm to map")
		)
	ExtendedWindows.create_setup_wizard(settings, "Change BPM")
	pass
func on_saving_new_file(path : String) -> void:
	RhythmComposer.clear_current_map()
	RhythmComposer.save_to_file(path)

func on_file_saved(path : String) -> void:
	RhythmComposer.save_to_file(path)

func on_file_loaded(path : String) -> void:
	RhythmComposer.load_from_file(path)

func on_new_music_selected(path : String) -> void:
	RhythmComposer.set_map_music(path)



func _on_play_test_pressed() -> void:
	#RhythmComposer.play_map(debug_preview.incoming_input)
	pass

func _on_record_toggled(toggled_on : bool) -> void:
	RhythmComposer.is_currently_recording = toggled_on
