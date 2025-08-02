@tool
extends BoxContainer

@export var input_indicator : PackedScene
@export var lane : PackedScene

var input_lanes : Dictionary[String, Control]

func create_input_indicator(action : String) -> Control:
	if !input_lanes.has(action):
		input_lanes[action] = create_lane()
	var indicator = input_indicator.instantiate()
	input_lanes[action].add_child(indicator)
	return indicator

func create_lane() -> Control:
	var ins = lane.instantiate()
	add_child(ins)
	return ins
