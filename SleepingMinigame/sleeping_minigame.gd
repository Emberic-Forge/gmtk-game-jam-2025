extends Node2D

@export var sleep_texture : Texture2D
@export var waking_texture : Texture2D
@export var half_sleep_texture : Texture2D
@export var awake_texture : Texture2D

var waking_progress = 0
var wake_up_index = 0

func _process( delta ):
	if ( !$RhythmGameplay.playing ):
		return
	
	var valid_press = false
	if ( Input.is_action_just_pressed("Action") ):
		if ( $RhythmGameplay._perform_action("Space") ):
			valid_press = true
	if ( Input.is_action_just_pressed("left") ):
		if ( $RhythmGameplay._perform_action("A") ):
			valid_press = true
	if ( Input.is_action_just_pressed("right") ):
		if ( $RhythmGameplay._perform_action("D") ):
			valid_press = true
	if ( Input.is_action_just_pressed("up") ):
		if ( $RhythmGameplay._perform_action("W") ):
			valid_press = true
	if ( Input.is_action_just_pressed("down") ):
		if ( $RhythmGameplay._perform_action("S") ):
			valid_press = true
			
	if ( valid_press ):
		_trigger_awake()
		waking_progress += 1
	
	if ( waking_progress >= 100 ):
		$RhythmGameplay.playing = false
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
