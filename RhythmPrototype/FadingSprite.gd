extends Sprite2D

func Show():
	visible = true
	var fadeInTween = get_tree().create_tween()
	fadeInTween.tween_property( self, "modulate:a", 1, 0.01 )
	await fadeInTween.finished
	fadeInTween.kill()
	var fadeOutTween = get_tree().create_tween()
	fadeOutTween.tween_property( self, "modulate:a", 0, 0.7 )
	await fadeOutTween.finished
	fadeOutTween.kill()
