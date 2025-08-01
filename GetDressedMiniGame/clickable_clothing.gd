extends Area2D

@export var clothing_zone : int
@export var clothing_id : int

signal on_clicked( clothing_zone, clothing_id, clothing_node )

func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if ( event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT ):
		on_clicked.emit( clothing_zone, clothing_id, self )
