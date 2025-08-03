extends Node2D

@export var toothbrush_arm : Sprite2D
@export var toothbrush_forearm : Sprite2D

var brush_progress = 0

var old_forearm_pos
var old_arm_pos

func _ready():
	old_forearm_pos = toothbrush_forearm.position
	old_arm_pos = toothbrush_arm.position

func _process( delta ):
	if ( !$RhythmGameplay.playing ):
		return
	
	var direction
	var valid_press = false
	var brush_magnitude = 40
	if ( Input.is_action_just_pressed("Action") ):
		if ( $RhythmGameplay._perform_action("Space") ):
			valid_press = true
	if ( Input.is_action_just_pressed("left") ):
		if ( $RhythmGameplay._perform_action("A") ):
			direction = Vector2(-brush_magnitude, 0)
			valid_press = true
	if ( Input.is_action_just_pressed("right") ):
		if ( $RhythmGameplay._perform_action("D") ):
			direction = Vector2(brush_magnitude, 0)
			valid_press = true
	if ( Input.is_action_just_pressed("up") ):
		if ( $RhythmGameplay._perform_action("W") ):
			direction = Vector2(0, -brush_magnitude)
			valid_press = true
	if ( Input.is_action_just_pressed("down") ):
		if ( $RhythmGameplay._perform_action("S") ):
			direction = Vector2(0, brush_magnitude)
			valid_press = true
			
	if ( valid_press ):
		_brush_teeth(direction)
		brush_progress += 3
		
func _brush_teeth( direction ):
	var forearm_tween = get_tree().create_tween()
	forearm_tween.tween_property( toothbrush_forearm, "position", toothbrush_forearm.position + direction, 0.1 )
	var arm_tween = get_tree().create_tween()
	arm_tween.tween_property( toothbrush_arm, "position", toothbrush_arm.position + direction/2, 0.1 )
	await forearm_tween.finished
	forearm_tween = get_tree().create_tween()
	arm_tween = get_tree().create_tween()
	forearm_tween.tween_property( toothbrush_forearm, "position", toothbrush_forearm.position - direction, 0.1 )
	arm_tween.tween_property( toothbrush_arm, "position", toothbrush_arm.position - direction/2, 0.1 )
	
	toothbrush_forearm.position = old_forearm_pos
	toothbrush_arm.position = old_arm_pos
	
