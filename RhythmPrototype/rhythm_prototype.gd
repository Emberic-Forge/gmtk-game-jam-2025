extends Node2D

@export var beats_per_minute = 60
@export var press_audio : AudioStreamPlayer2D
@export var snare_audio : AudioStreamPlayer2D

@export var poor_sprite : Sprite2D
@export var ok_sprite : Sprite2D
@export var good_sprite : Sprite2D
@export var perfect_sprite : Sprite2D

@export var ok_timing = 0.3
@export var good_timing = 0.1
@export var perfect_timing = 0.05

var current_time = 0

func _process( delta ):
	current_time += delta
	var beat_time = 60/beats_per_minute
	
	if ( Input.is_action_just_pressed("Action") ):
		var offset = current_time
		if ( current_time > (beat_time / 2.0) ):
			offset = abs( current_time - beat_time )
		
		var desired_sprite : Sprite2D
		if ( offset < perfect_timing ):
			desired_sprite = perfect_sprite
		elif ( offset < good_timing ):
			desired_sprite = good_sprite
		elif ( offset < ok_timing ):
			desired_sprite = ok_sprite
		else:
			desired_sprite = poor_sprite
			
		var random_angle = randi_range( 0, 365 )
		var sprite_offset = Vector2( 150, 0 )
		var random_rotated_offset = sprite_offset.rotated( random_angle )
		desired_sprite.position = random_rotated_offset + $Circle.position
		desired_sprite.rotation = random_angle
		desired_sprite.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property( desired_sprite, "modulate:a", 1, 0.01 )
		
		press_audio.play()
	
	var tween = get_tree().create_tween()
	if ( current_time > beat_time ):
		snare_audio.play()
		current_time = 0
		tween.tween_property( $Circle, "scale", Vector2( 1, 1 ), 0.1)
	else:
		tween.tween_property( $Circle, "scale", Vector2( 0.2, 0.2 ), 0.1)
