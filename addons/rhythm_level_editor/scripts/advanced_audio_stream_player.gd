@tool
class_name AdvancedAudioStreamPlayer extends AudioStreamPlayer

@export var observed_stream : AudioStream:
	set(value):
		if value:
			on_stream_assigned.emit()
		else:
			on_stream_removed.emit()
		stream = value
	get: return stream

signal on_stream_assigned
signal on_stream_removed
