extends Node

@export var beats_per_minute = 60
@export var press_success_audio = preload("res://GlobalAssets/Audio/PressSuccess.wav")
@export var press_miss_audio = preload("res://GlobalAssets/Audio/PressMiss.wav")
@export var snare_audio = preload("res://GlobalAssets/Audio/Snare.mp3")
@export var hi_hat_audio = preload("res://GlobalAssets/Audio/HiHat.mp3")

@export var use_count_down = false
@export var success_timing = 0.1

var tracking_info = preload("res://GlobalAssets/AudioData/OhDeerTrackInfo.json")

var current_time = 0
var beat_time

var music_audio_player
var press_audio_player

var playing = true

func _ready():
	press_audio_player = AudioStreamPlayer.new()
	add_child(press_audio_player)
	
	music_audio_player = AudioStreamPlayer.new()
	add_child(music_audio_player)
	
	beat_time = 60.0/beats_per_minute

func _process( delta ):
	if ( !playing ):
		return
	
	current_time += delta
	var is_on_beat = current_time > beat_time
		
	if ( is_on_beat ):
		music_audio_player.set_stream(snare_audio)
		music_audio_player.play()
		current_time = 0

func _perform_action():
	var success = false
	var offset = current_time
	var overshoot = true
	if ( current_time > (beat_time / 2.0) ):
		offset = abs( current_time - beat_time )
		overshoot = false
		
	if (offset < success_timing):
		success = true
		
	if ( !success ):
		press_audio_player.set_stream(press_miss_audio)
		press_audio_player.play()
		return false
	if ( success ):
		press_audio_player.set_stream(press_success_audio)
		press_audio_player.play()
		return true
