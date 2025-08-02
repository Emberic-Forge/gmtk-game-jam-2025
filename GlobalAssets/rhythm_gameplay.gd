extends Node

@export var beats_per_minute = 60
@export var press_success_audio = preload("res://GlobalAssets/Audio/PressSuccess.wav")
@export var press_miss_audio = preload("res://GlobalAssets/Audio/PressMiss.wav")
@export var music_audio = preload("res://GlobalAssets/Audio/OhDeerMyBeer.wav")

@export var right_input = preload("res://GlobalAssets/Art/UI/RightArrow.svg")
@export var left_input = preload("res://GlobalAssets/Art/UI/LeftArrow.svg")
@export var up_input = preload("res://GlobalAssets/Art/UI/UpArrow.svg")
@export var down_input = preload("res://GlobalAssets/Art/UI/DownArrow.svg")

@export var rhythm_location : Marker2D

@export var use_count_down = false
@export var success_timing = 0.1
@export var height_per_second = 400

enum GameMode { SLEEP, DRESS, DRIVE, BRUSH }
@export var game_mode = GameMode.SLEEP

var track_info

var current_time = 0
var beat_time

var music_audio_player
var press_audio_player

var rhythm_scroll

var playing = true

func _ready():
	press_audio_player = AudioStreamPlayer.new()
	add_child(press_audio_player)
	
	music_audio_player = AudioStreamPlayer.new()
	add_child(music_audio_player)
	music_audio_player.set_stream( music_audio )
	music_audio_player.play()
	
	var json = JSON.new()
	track_info = json.parse_string( FileAccess.get_file_as_string("res://GlobalAssets/AudioData/OhDeerTrackData.json") )
	
	if ( game_mode == GameMode.SLEEP ):
		rhythm_scroll = Node2D.new()
		rhythm_location.add_child( rhythm_scroll )
		for note in track_info["notes"]:
			var desired_sprite
			var desired_offset
			var desired_horizontal_offset = 50
			if ( note.keys()[0] == "A" ):
				desired_sprite = left_input
				desired_offset = desired_horizontal_offset * 0 
			elif ( note.keys()[0] == "W"):
				desired_sprite = up_input
				desired_offset = desired_horizontal_offset * 1
			elif ( note.keys()[0] == "S"):
				desired_sprite = down_input
				desired_offset = desired_horizontal_offset * 2
			elif ( note.keys()[0] == "D"):
				desired_sprite = right_input
				desired_offset = desired_horizontal_offset * 3
			var spawned_sprite = Sprite2D.new()
			spawned_sprite.texture = desired_sprite
			rhythm_scroll.add_child( spawned_sprite )
			spawned_sprite.position = Vector2( desired_offset, -note.get(note.keys()[0]) * height_per_second )
	
	beat_time = 60.0/beats_per_minute

func _process( delta ):
	if ( !playing ):
		return
		
	current_time += delta
	
	if ( game_mode == GameMode.SLEEP ):
		var note_children = rhythm_location.get_children()[1].get_children()
		for note_child in note_children :
			note_child.position.y += delta*height_per_second
			if note_child.position.y > 0:
				note_child.visible = false

func _perform_action( key ):
	var success = false
	
	if ( game_mode == GameMode.SLEEP ):
		for note in track_info["notes"]:
			if ( note.keys()[0] == key ):
				if ( abs( current_time - note[note.keys()[0]]) < success_timing ):
					success = true
	
	if ( !success ):
		press_audio_player.set_stream(press_miss_audio)
		press_audio_player.play()
		return false
	if ( success ):
		press_audio_player.set_stream(press_success_audio)
		press_audio_player.play()
		return true
