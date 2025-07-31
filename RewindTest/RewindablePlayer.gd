extends CharacterBody2D

@export var walk_speed = 100
@export var rewind_character_scene : PackedScene
@export var rewind_children : Node

@export var record_rate = 0.1
var record_timer = record_rate

var current_time = 0
var inputCombined

class RecordedData:
	var position : Vector2
	var timestamp : float
	
class RecordedDataArray:
	var recorded_data_array = []

var current_recorded_data = []

var all_recorded_data = []

func get_input(delta):	
	var inputForward = -Input.get_axis("brake", "forward")
	var inputSideways = Input.get_axis("left", "right")
	
	inputCombined = Vector2( inputSideways, inputForward )
	

func _physics_process(delta):
	get_input(delta)
	position += inputCombined * walk_speed * delta
	move_and_slide()
	
	current_time += delta
	record_timer -= delta
	if ( record_timer < 0 ):
		record_timer = record_rate
		var data = RecordedData.new()
		data.position = position
		data.timestamp = current_time
		current_recorded_data.append( data )
		
	var rewindCharacters = rewind_children.get_children()
	
	for i in range( 0, all_recorded_data.size()) :
		for recordedData in all_recorded_data[i].recorded_data_array:
			if ( recordedData.timestamp > current_time ):
				rewindCharacters[i].get_children()[0].position = recordedData.position
				break


func _on_rewind_button_pressed() -> void:
	current_time = 0
	var dataToAdd = RecordedDataArray.new()
	dataToAdd.recorded_data_array = current_recorded_data
	all_recorded_data.append(dataToAdd)
	position = Vector2(0,0)
	current_recorded_data = []
	rewind_children.add_child( rewind_character_scene.instantiate() )
