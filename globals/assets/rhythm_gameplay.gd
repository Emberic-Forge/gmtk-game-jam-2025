class_name RhythmGameplay extends Node

class DressNote:
	var clothing_sprites : Array[Sprite2D]
	var clothing_id : Array[int]
	var time : float

enum GameMode { SLEEP, DRESS, DRIVE, BRUSH }

const NAME = "name"
const NOTES = "notes"
const MUSIC = "music"
const OFFSET = "offset"
const BPM = "bpm"

@export_group("Music")
@export var beats_per_minute = 60
@export var press_success_audio : AudioStream = preload("res://GlobalAssets/Audio/PressSuccess.wav")
@export var press_miss_audio : AudioStream = preload("res://GlobalAssets/Audio/PressMiss.wav")
@export var music_audio : AudioStream = preload("res://GlobalAssets/Audio/OhDeerMyBeer.wav")

@export_group("Input Indicators")
@export var right_input : CompressedTexture2D = preload("res://GlobalAssets/Art/UI/RightArrow.svg")
@export var left_input : CompressedTexture2D = preload("res://GlobalAssets/Art/UI/LeftArrow.svg")
@export var up_input : CompressedTexture2D = preload("res://GlobalAssets/Art/UI/UpArrow.svg")
@export var down_input : CompressedTexture2D = preload("res://GlobalAssets/Art/UI/DownArrow.svg")

@export var rhythm_location : Marker2D

@export_group("Timings")
@export var use_count_down = false
@export var success_timing = 0.1
@export var height_per_second = 400

@export_group("Game Mode")
@export var game_mode = GameMode.SLEEP

@export var dressed_beats = 1

@export_group("Other")
@export_file("*.json") var track_path : String

var dress_notes = []
@export var clothing_sprites : Array[Sprite2D]

var track_info

var current_time : float = 0
var beat_time : float

var music_audio_player : AudioStreamPlayer
var press_audio_player : AudioStreamPlayer

var rhythm_scroll : Node2D

var playing = true

func _ready():
	press_audio_player = AudioStreamPlayer.new()
	add_child(press_audio_player)

	rhythm_scroll = Node2D.new()
	rhythm_location.add_child( rhythm_scroll )

func _process(delta : float) -> void:
	update_visuals(delta)

func update_visuals(delta : float) -> void:
	current_time += delta
	var note_children = rhythm_scroll.get_children()
	for note_child in note_children :
		note_child.position.y += delta*height_per_second
		if note_child.position.y > 0:
			note_child.visible = false


func _perform_action( key : String , note : Dictionary ):

	var success = note.keys()[0] == key and abs( current_time - note[note.keys()[0]]) < success_timing
	play_trigger_sfx(success)
	return success

func spawn_note(key : String, note : Dictionary) -> void:
	const LEFT := "left"
	const UP := "up"
	const DOWN := "down"
	const RIGHT := "right"

	const DESIRED_HORIZONTAL_OFFSET = 50
	beat_time = 60.0/beats_per_minute



	# Select the correct sprite texture and offset
	var desired_sprite
	var desired_offset

	match key:
		LEFT:
			desired_sprite = left_input
			desired_offset = DESIRED_HORIZONTAL_OFFSET * 0
		UP:
			desired_sprite = up_input
			desired_offset = DESIRED_HORIZONTAL_OFFSET * 1
		DOWN:
			desired_sprite = down_input
			desired_offset = DESIRED_HORIZONTAL_OFFSET * 2
		RIGHT:
			desired_sprite = right_input
			desired_offset = DESIRED_HORIZONTAL_OFFSET * 3

	# Create sprite 2d node and assign the selected sprite
	var spawned_sprite = Sprite2D.new()
	spawned_sprite.texture = desired_sprite
	# Add it to the scrolling node
	rhythm_scroll.add_child( spawned_sprite )
	# Set its position of the sprite to match the timings
	spawned_sprite.position = Vector2( desired_offset, -note.get(key) * height_per_second )

func play_trigger_sfx(sfx_type : int) -> void:
	const SUCCESS : int = 1
	const FAIL : int = 0

	match(sfx_type):
		SUCCESS:
			press_audio_player.set_stream(press_success_audio)
		FAIL:
			press_audio_player.set_stream(press_success_audio)

	press_audio_player.play()

func load_from_file(path : String) -> Dictionary:
	var result : Dictionary
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_as_text()
	var json := JSON.new()
	var error := json.parse(data)
	if error == OK:
		result = json.data as Dictionary
		verify_map(result)

		print("loaded map - %s" % path)
		return result
	else:
		printerr("Failed to load file at [%s]" % path)
		return {}

func verify_map(map : Dictionary) -> void:
	if not map.has(OFFSET):
		map[OFFSET] = 0

	if not map.has(MUSIC):
		map[MUSIC] = null

	if not map.has(NOTES):
		map[NOTES] = []

	if not map.has(NAME):
		map[NAME] = "new_map"

	if not map.has(BPM):
		map[BPM] = 60
