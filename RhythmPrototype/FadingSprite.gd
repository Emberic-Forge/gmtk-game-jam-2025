extends Sprite2D

func _process( delta ):
	var tween = get_tree().create_tween()
	if ( visible == true ):
		tween.tween_property( self, "modulate:a", 0, 0.2 )
		await tween.finished
		tween.kill()
