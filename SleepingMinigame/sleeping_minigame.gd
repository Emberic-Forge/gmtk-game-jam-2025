extends Node2D

@export var beats_per_minute = 60
@export var press_audio : AudioStreamPlayer2D
@export var snare_audio : AudioStreamPlayer2D

@export var sleep_texture : Texture2D
@export var waking_texture : Texture2D
@export var half_sleep_texture : Texture2D
@export var awake_texture : Texture2D

@export var success_timing = 0.05

var current_time = 0
var waking_progress = 0

var wake_up_index = 0

var success = false

func _process( delta ):
	current_time += delta
	var beat_time = 60.0/beats_per_minute
	
	if ( Input.is_action_just_pressed("Action") ):
		var offset = current_time
		if ( current_time > (beat_time / 2.0) ):
			offset = abs( current_time - beat_time )
		if (offset < success_timing):
			_trigger_awake()
			waking_progress += 10
		press_audio.play()
	
	if ( waking_progress >= 100 ):
		success = true
		$Character.texture = awake_texture
		await get_tree().create_timer(1).timeout
		$Character.texture = sleep_texture
		await get_tree().create_timer(0.5).timeout
		$Character.texture = awake_texture
		await get_tree().create_timer(1).timeout
		$Character.texture = sleep_texture
		await get_tree().create_timer(0.5).timeout
		$Character.texture = awake_texture
		$WakingProgress.text = "AWAKE!"
	else:
		$WakingProgress.text = "%d/100" % waking_progress
		
		var tween = get_tree().create_tween()
		if ( current_time > beat_time ):
			snare_audio.play()
			current_time = 0

func _trigger_awake():
	$Character.texture = waking_texture
	var wake_up_sprites = $WakeUpSprites.get_children()
	
	var rand = 0
	while true :
		rand = randi_range( 0, wake_up_sprites.size() - 1 )
		if ( rand != wake_up_index ):
			break
	wake_up_sprites[rand].Show()
	wake_up_index = rand
	
	_shake_sprite()
	await get_tree().create_timer(0.4).timeout
	if ( waking_progress < 50):
		$Character.texture = sleep_texture
	else:
		$Character.texture = half_sleep_texture
		

func _shake_sprite():
	var shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Character, "position:x", $Character.position.x + 10, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Character, "position:x", $Character.position.x - 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Character, "position:x", $Character.position.x + 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Character, "position:x", $Character.position.x - 10, 0.05)
