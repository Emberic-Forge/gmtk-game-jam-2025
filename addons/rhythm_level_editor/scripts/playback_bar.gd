@tool
extends PanelContainer

@export var player : AdvancedAudioStreamPlayer:
	set(value):
		audio_player = value
		if audio_player:
			bind_events()
			update_timeline()

	get: return audio_player

@export var music_label : Label
@export var timer : Label
@export var timeline : HSlider
@export var minimap : BoxContainer


var paused_pos : float
var audio_player : AdvancedAudioStreamPlayer


func _process(delta : float) -> void:
	if player and player.playing:
		timeline.value = player.get_playback_position()
		RhythmComposer.print_data_at_position(player.get_playback_position())

func _on_stop_pressed() -> void:
	paused_pos = 0
	player.stop()

func _on_play_pressed() -> void:
	player.play(paused_pos)


func _on_pause_pressed() -> void:
	paused_pos = player.get_playback_position()
	player.stop()

func reset_playback() -> void:
	paused_pos = 0
	timeline.value = 0

func _on_timeline_value_changed(value : float) -> void:
	var minutes := value / 60
	var seconds := fmod(value, 60)
	timer.text = "%02d:%02d" % [minutes, seconds]

	if player and not player.playing:
		paused_pos = value

func add_input_to_minimap(action : StringName) -> void:
	pass

func update_timeline() -> void:
	var audio_clip := audio_player.stream
	timeline.max_value = audio_clip.get_length() if audio_clip else 0
	music_label.text = audio_clip.resource_path.get_file().get_basename() if audio_clip else "---"
	print(music_label.text)
	print("timeline updated!")

func bind_events() -> void:
	if RhythmComposer.on_file_loaded.is_connected(update_timeline):
		RhythmComposer.on_file_loaded.disconnect(update_timeline)
	RhythmComposer.on_file_loaded.connect(update_timeline)

	if  audio_player.on_stream_assigned.is_connected(update_timeline):
		audio_player.on_stream_assigned.disconnect(update_timeline)
	audio_player.on_stream_assigned.connect(update_timeline)

	if  audio_player.on_stream_removed.is_connected(update_timeline):
		audio_player.on_stream_removed.disconnect(update_timeline)
	audio_player.on_stream_removed.connect(update_timeline)
	print("registered events")

func time_to_pixel_coordinates(time_point : float) -> float:
	if !audio_player || !audio_player.stream:
		return -1
	var length = audio_player.stream.get_length()
	var minimap_width = minimap.size.x
	return (time_point / length) * minimap_width
