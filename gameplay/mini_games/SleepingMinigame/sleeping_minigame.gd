extends BaseMiniGame

@export var sleep_texture : Texture2D
@export var waking_texture : Texture2D
@export var half_sleep_texture : Texture2D
@export var awake_texture : Texture2D

@onready var rhythm_gameplay : Node = $RhythmGameplay
@onready var character : Sprite2D = $Character
@onready var waking_progress_label : RichTextLabel = $WakingProgress
@onready var wake_up_sprites : Node = $WakeUpSprites

@export var target_progress : int = 10


var waking_progress = 0
var wake_up_index = 0

func _process( delta ):
	if ( !rhythm_gameplay.playing ):
		return

	var valid_press = false
	if ( Input.is_action_just_pressed("Action") ):
		if ( rhythm_gameplay._perform_action("Space") ):
			valid_press = true
	if ( Input.is_action_just_pressed("left") ):
		if ( rhythm_gameplay._perform_action("A") ):
			valid_press = true
	if ( Input.is_action_just_pressed("right") ):
		if ( rhythm_gameplay._perform_action("D") ):
			valid_press = true
	if ( Input.is_action_just_pressed("up") ):
		if ( rhythm_gameplay._perform_action("W") ):
			valid_press = true
	if ( Input.is_action_just_pressed("down") ):
		if ( rhythm_gameplay._perform_action("S") ):
			valid_press = true

	if ( valid_press ):
		_trigger_awake()
		waking_progress += 3

	if ( waking_progress >= target_progress ):
		rhythm_gameplay.playing = false
		character.texture = awake_texture
		await get_tree().create_timer(1).timeout
		character.texture = sleep_texture
		await get_tree().create_timer(0.5).timeout
		character.texture = awake_texture
		await get_tree().create_timer(1).timeout
		character.texture = sleep_texture
		await get_tree().create_timer(0.5).timeout
		character.texture = awake_texture
		waking_progress_label.text = "AWAKE!"
	else:
		waking_progress_label.text = "%d/100" % waking_progress

		var tween = get_tree().create_tween()

func _trigger_awake():
	character.texture = waking_texture
	var wake_up_sprites = wake_up_sprites.get_children()

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
		character.texture = sleep_texture
	else:
		character.texture = half_sleep_texture


func _shake_sprite():
	var shakeTween = get_tree().create_tween()
	shakeTween.tween_property(character, "position:x", character.position.x + 10, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( character, "position:x", character.position.x - 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( character, "position:x", character.position.x + 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( character, "position:x",character.position.x - 10, 0.05)
