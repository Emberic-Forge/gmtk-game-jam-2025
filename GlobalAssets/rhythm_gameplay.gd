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

@export var dressed_beats = 1

class DressNote:
	var clothing_sprites : Array[Sprite2D]
	var clothing_id : Array[int]
	var time : float

var dress_notes = []
@export var clothing_sprites : Array[Sprite2D]

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
	
	var desired_horizontal_offset = 50
	beat_time = 60.0/beats_per_minute
	
	rhythm_scroll = Node2D.new()
	rhythm_location.add_child( rhythm_scroll )
	
	if ( game_mode == GameMode.SLEEP || game_mode == GameMode.BRUSH ):
		for note in track_info["notes"]:
			var desired_sprite
			var desired_offset
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
	elif ( game_mode == GameMode.DRESS ):
		var time = 0
		desired_horizontal_offset = 100
		for i in range( 1, 50 ):
			time += dressed_beats * beat_time
			var dress_note = DressNote.new()
			var dress_options = [0, 1, 2, 3, 4, 5]
			while true :
				var rand_pick = randi_range(0, 5)
				if ( dress_options.find( rand_pick ) ):
					dress_options.remove_at( dress_options.find( rand_pick ) )
				if ( dress_options.size() == 4):
					break
			var desired_offset = 0
			for j in range(0, 4):
				var found_idx = randi_range( 0, dress_options.size()-1 )
				var found =  dress_options[ found_idx ]
				dress_options.remove_at( found_idx )
				dress_note.clothing_sprites.append( clothing_sprites[found] )
				dress_note.clothing_id.append( found )
			
				var spawned_sprite = clothing_sprites[found].duplicate()
				rhythm_scroll.add_child( spawned_sprite )
				spawned_sprite.position = Vector2( desired_offset, -i * height_per_second )
				desired_offset += desired_horizontal_offset
			
			dress_note.time = time
			dress_notes.append(dress_note)

func _process( delta ):
	if ( !playing ):
		return
		
	current_time += delta
	
	var note_children = rhythm_scroll.get_children()
	for note_child in note_children :
		note_child.position.y += delta*height_per_second
		if note_child.position.y > 0:
			note_child.visible = false

func _perform_action( key ):
	var success = false
	var dress_beat_chosen = 0
	if ( game_mode == GameMode.SLEEP || game_mode == GameMode.BRUSH ):
		for note in track_info["notes"]:
			if ( note.keys()[0] == key ):
				if ( abs( current_time - note[note.keys()[0]]) < success_timing ):
					success = true
					break
	elif ( game_mode == GameMode.DRESS ):
		for note in dress_notes:
			if ( abs( current_time - note.time) < success_timing ):
				success = true
				break
			dress_beat_chosen += 1
	
	if ( !success ):
		press_audio_player.set_stream(press_miss_audio)
		press_audio_player.play()
		return false
	if ( success ):
		press_audio_player.set_stream(press_success_audio)
		press_audio_player.play()
		if ( game_mode == GameMode.DRESS ):
			var desired_dress
			if ( key == "A"):
				desired_dress = 0
			if ( key == "W"):
				desired_dress = 1
			if ( key == "S"):
				desired_dress = 2
			if ( key == "D"):
				desired_dress = 3
			return dress_notes[dress_beat_chosen].clothing_id[desired_dress] + 1
		return true
