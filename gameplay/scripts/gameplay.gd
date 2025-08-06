class_name Gameplay extends Node

const NOTES := "notes"
const BPM := "bpm"
const BASE_BPM_TIME := 60

@export var map_path : Array[String]

@export_group("Audio")
@export var snare_sfx : AudioStream
@export var hit_sfx : AudioStream
@export var mis_sfx : AudioStream

@onready var music_player : AudioStreamPlayer = $"Music Player"
@onready var sfx_player : AudioStreamPlayer = $"SFX Player"

@onready var input_listener : InputListener = $InputListener
@onready var flipbook : AnimatedSprite2D = $Scene/Flipbook

var map : Dictionary
var current_time := 0.0
var target_beat := 0.0
var note_indx := 0

signal on_game_over
signal on_beat

func _ready() -> void:
	load_map(map_path[0])

func load_map(map_path : String) -> void:
	# Load the json file from the path
		# Verify that the path is valid

	# Parse the map and store it to the map variable
	# Enable the input listener
	pass

func get_next_target(map : Dictionary) -> float:
	note_indx += 1
	return get_timings(map[NOTES][note_indx])

func get_timings(note : Dictionary) -> float:
	return note.values()[0]

func _process(delta : float) -> void:
	if !map:
		return

	current_time += delta

	var is_on_beat = current_time > target_beat
	if is_on_beat:
		current_time = 0
		on_beat.emit()
		target_beat = get_next_target(map)
