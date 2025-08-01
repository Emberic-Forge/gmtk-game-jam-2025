@tool
extends Node

const NAME = "name"
const NOTES = "notes"
const MUSIC = "music"
const OFFSET = "offset"

var current_map : Dictionary
var is_currently_recording : bool

func _enter_tree() -> void:
	current_map = initialize_empty_slate()
	pass

#File Parsing
func load_from_file(path : String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_as_text()
	var json := JSON.new()
	var error := json.parse(data)
	if error == OK:
		current_map = json.data
	else:
		printerr("Failed to load file at [%s]" % path)

func save_to_file(path : String) -> void:
	var json_data = JSON.stringify(current_map)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json_data)

func clear_current_map() -> void:
	current_map = {}

func play_map(prepare_input : Callable) -> void:
	pass

#Getters
func get_map_name() -> String:
	return current_map[NAME]

func get_map_offset() -> float:
	return current_map[OFFSET]

func get_map_music() -> AudioStream:
	return load(current_map[MUSIC])

func get_map_music_path() -> String:
	return current_map[MUSIC]

#Setters
func set_map_name(new_name : String) -> void:
	current_map[NAME] = new_name

func set_map_offset(new_value : float) -> void:
	current_map[OFFSET] = new_value

func set_map_music(path : String) -> void:
	current_map[MUSIC] = path

func read_input(incoming_input : InputEvent, time_stamp : float) -> void:
	if incoming_input is not InputEventKey || not is_currently_recording || incoming_input.is_released():
		return
	print("%s - %f" % [incoming_input.as_text(), time_stamp])
	current_map[NOTES].append({incoming_input.as_text() : time_stamp - current_map[OFFSET]})

func initialize_empty_slate() -> Dictionary:
	return {
		NAME : "new_map",
		NOTES : [],
		MUSIC : null,
		OFFSET : 0,
	}
