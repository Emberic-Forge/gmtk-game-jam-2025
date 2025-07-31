extends CharacterBody2D

@export var maxSpeed = 600
@export var rotation_speed = 1.5
@export var acceleration = 600
@export var brakeForce = 400
@export var velocityDecay = 100

var rotation_direction = 0

var currentSpeed = 0

var pausedToSelectUpgrade = false

func get_input(delta):
	rotation_direction = Input.get_axis("left", "right")
	
	if ( Input.is_action_pressed(&"forward") ):
		currentSpeed = minf( currentSpeed + ( acceleration * delta ), maxSpeed )
	elif (Input.is_action_pressed(&"brake") ):
		currentSpeed = maxf( currentSpeed - ( brakeForce * delta), 0 )
	else:
		currentSpeed = maxf( currentSpeed - ( velocityDecay * delta), 0 )
	velocity = transform.y * -currentSpeed

func _physics_process(delta):
	$Camera2D/Control.rotation = 0
	if ( pausedToSelectUpgrade ):
		return
	
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()


func _on_finish_line_body_entered(body: Node2D) -> void:
	pausedToSelectUpgrade = true
	$Camera2D/Control.visible = true


func _on_choice_1_pressed() -> void:
	maxSpeed += 600
	pausedToSelectUpgrade = false
	$Camera2D/Control.visible = false


func _on_choice_2_pressed() -> void:
	rotation_speed += 1.5
	pausedToSelectUpgrade = false
	$Camera2D/Control.visible = false


func _on_choice_3_pressed() -> void:
	acceleration += 600
	pausedToSelectUpgrade = false
	$Camera2D/Control.visible = false
	
