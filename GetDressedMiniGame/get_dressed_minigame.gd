extends Node2D

var clothing_click_order = []

var equipped_clothes = []
var clothes_labels = []

@export var beats_per_minute = 60
@export var press_audio : AudioStreamPlayer2D
@export var snare_audio : AudioStreamPlayer2D

var current_time = 0
var beat_time
@export var success_timing = 0.05

func _process( delta ):
	current_time += delta
	beat_time = 60.0/beats_per_minute
	
	if ( current_time > beat_time ):
		snare_audio.play()
		current_time = 0

func _ready():
	var clothing_buttons = $ClothingButtons.get_children()
	for clothing_button in clothing_buttons:
		clothing_button.on_clicked.connect( _on_clicked )
	
	clothes_labels = $ClothesList.get_children()
	
	equipped_clothes = $Man.get_children()
	for equipped_clothing in equipped_clothes:
		equipped_clothing.visible = false

func _on_clicked( clothing_zone, clothing_id, clothing_node ) :
	var offset = current_time
	if ( current_time > (beat_time / 2.0) ):
		offset = abs( current_time - beat_time )
	if (offset < success_timing):
		clothing_node.visible = false
		clothing_node.input_pickable = false
		clothing_click_order.append(clothing_zone)
		for equipped_clothing in equipped_clothes :
			if ( equipped_clothing.clothing_id == clothing_id):
				equipped_clothing.visible = true
				equipped_clothing.z_index = clothing_click_order.size()
		
		for clothes_label in clothes_labels :
			if ( clothes_label.clothing_id == clothing_id ):
				clothes_label.modulate.a = 1
		
		if ( clothing_click_order.size() == equipped_clothes.size() ):
			var is_valid_order = true
			var running_max = -1
			for clothing_click in clothing_click_order:
				if ( clothing_click < running_max ):
					is_valid_order = false
					break
				running_max = clothing_click
			
			var tween = get_tree().create_tween()
			tween.tween_property( $Man, "position:x", $Man.position.x + 1200, 2)
			await tween.finished
			tween.kill()
			if ( is_valid_order ):
				$Success.visible = true
			else:
				$Failure.visible = true
	else:
		_shake_sprite()
		
	press_audio.play()
	

func _shake_sprite():
	var shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Man, "position:x", $Man.position.x + 10, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Man, "position:x", $Man.position.x - 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Man, "position:x", $Man.position.x + 20, 0.05)
	await shakeTween.finished
	shakeTween.kill
	shakeTween = get_tree().create_tween()
	shakeTween.tween_property( $Man, "position:x", $Man.position.x - 10, 0.05)
