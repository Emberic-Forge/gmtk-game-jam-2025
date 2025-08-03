extends CharacterBody3D

@export var lane_distance = 40
@export var forward_velocity = 80
@export var turn_velocity = 3

var current_lane : int = 0
var desired_lane : int = 0

func _physics_process(delta):
	if ( current_lane != desired_lane ):
		if ( current_lane > desired_lane ):
			current_lane = maxf( desired_lane, current_lane - turn_velocity * delta )
		else:
			current_lane = minf( desired_lane, current_lane + turn_velocity * delta )
		position.x = current_lane * lane_distance
	else:
		if (Input.is_action_just_pressed("right")):
			desired_lane = mini( desired_lane + 1, 3 )
		elif (Input.is_action_just_pressed("left")):
			desired_lane = maxi( desired_lane - 1, 0 )

	if ( position.z < -500 ):
		position.z = 0

	velocity.z = -forward_velocity
	move_and_slide()
