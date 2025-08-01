@tool
extends PanelContainer

@export var player : AdvancedAudioStreamPlayer:
	set(value):
		audio_player = value
		if audio_player:
			audio_player.on_stream_assigned.connect(update_timeline.bind(audio_player.stream))
			audio_player.on_stream_removed.connect(update_timeline.bind(null))

@onready var timer : Label = $Order/Controls/Timer
@onready var timeline = $Order/Timeline

var paused_pos : float
var audio_player : AdvancedAudioStreamPlayer


func _process(delta : float) -> void:
	if player and player.playing:
		timeline.value = player.get_playback_position()

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

	if not player.playing:
		paused_pos = value

func update_timeline(audio_clip : AudioStream) -> void:
	timeline.max_value = audio_clip.get_length() if audio_clip else 0
