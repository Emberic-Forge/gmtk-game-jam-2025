@tool
class_name AdvancedAudioStreamPlayer extends AudioStreamPlayer

@export var foo :int = -1
var previous_stream : AudioStream

signal on_stream_assigned
signal on_stream_removed

func _process(_delta : float) -> void:
	if stream != previous_stream:
		previous_stream = stream
		if stream:
			on_stream_assigned.emit()
		else:
			on_stream_removed.emit()
