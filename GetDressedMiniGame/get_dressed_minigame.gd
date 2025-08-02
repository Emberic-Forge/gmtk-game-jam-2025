extends Node2D

var clothing_click_order = []

var equipped_clothes = []
var clothes_labels = []

func _process( delta ):
	pass

enum DirectionalInputs { UP, DOWN, LEFT, RIGHT}

func process():
	var clothing_buttons = $ClothingButtons.get_children()
	for clothing_button in clothing_buttons:
		clothing_button.on_clicked.connect( _on_clicked )
	
	equipped_clothes = $Man.get_children()
	for equipped_clothing in equipped_clothes:
		equipped_clothing.visible = false

func _on_clicked( clothing_zone, clothing_id, clothing_node ) :
	if ( $RhythmGameplay._perform_action() ):
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
