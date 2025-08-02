class_name RhythmPrototype extends Node2D

@export_group("Audio")
@export var beats_per_minute = 60
@export var press_audio : AudioStreamPlayer2D
@export var snare_audio : AudioStreamPlayer2D

@export_group("Sprites")
@export var poor_sprite : Sprite2D
@export var ok_sprite : Sprite2D
@export var good_sprite : Sprite2D
@export var perfect_sprite : Sprite2D

@export_group("Timings")
@export var target_points : int = 10
@export_subgroup("Ok")
@export_range(0,1,0.001) var ok_timing : float = 0.3
@export var ok_point : float = 0.5
@export_subgroup("Good")
@export_range(0,1,0.001) var good_timing : float = 0.1
@export var good_point : float = 1
@export_subgroup("Perfect")
@export_range(0,1,0.001) var perfect_timing : float = 0.05
@export var perfect_point : float = 2

@onready var score : Label = $HUD/Score

var current_time = 0
var accumilated_points : int = 0
var root : Root


func initialize(root : Root) -> void:
	self.root = root


func _process( delta ):
	current_time += delta
	var beat_time = 60.0/beats_per_minute

	if ( Input.is_action_just_pressed("Action") ):
		var offset = current_time
		if ( current_time > (beat_time / 2.0) ):
			offset = abs( current_time - beat_time )

		var desired_sprite : Sprite2D
		if ( offset < perfect_timing ):
			desired_sprite = perfect_sprite
			accumilated_points += perfect_point
		elif ( offset < good_timing ):
			desired_sprite = good_sprite
			accumilated_points += good_point
		elif ( offset < ok_timing ):
			desired_sprite = ok_sprite
			accumilated_points += ok_point
		else:
			desired_sprite = poor_sprite
			accumilated_points -= perfect_point

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

	if accumilated_points >= target_points:
		root.goto_next_mini_game()
		accumilated_points = 0
	score.text = "%f" % accumilated_points
