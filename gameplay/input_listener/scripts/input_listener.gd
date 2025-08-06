class_name InputListener extends Node

const NOTES := "notes"
const SUCCESS_TIMING := 0.1

var root : Gameplay
var processed_input : Array

signal on_input_success
signal on_input_failed

func set_root_reference(gameplay : Gameplay) -> void:
	root = gameplay

func is_input_timed(key : String, current_timepoint : float,target_timepoint : float) -> bool:
	# Fetch the info from the map and the current time point of the track
	# See if any note was pressed in time and not missed.

	var success = note.keys()[0] == key and abs( current_time - note[note.keys()[0]]) < target_timepoint
	play_trigger_sfx(success)
	return success

func play_trigger_sfx(succeeded : bool) -> void:
	pass

func get_key(note : Dictionary) -> String:
	return note.keys()[0]

func get_timings(note : Dictionary) -> float:
	return note.values()[0]


func _process(delta : float) -> void:
	var timepoint : float = root.get_track_timepoint()
	for note in root.map[NOTES]:
		var key := get_key(note)
		var timings := get_timings(note)
		if not processed_input.has(key):
			if is_input_timed(key, timepoint, SUCCESS_TIMING):
				on_input_success.emit()
			else:
				on_input_failed.emit()
			processed_input.append(key)
