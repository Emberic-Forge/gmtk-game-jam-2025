extends BaseMiniGame

var clothing_click_order = []

var equipped_clothes = []
var clothes_labels = []

var next_clothes_press_time
var clothes_press_order = []
var root : Root

@onready var rhythm_gameplay = $RhythmGameplay

func _ready():
	equipped_clothes = $Man.get_children()
	for equipped_clothing in equipped_clothes:
		equipped_clothing.visible = false

func play(root : Root) -> void:
	self.root = root

func _process( delta ):
	var valid_press = false
	var pressed_clothing = 0
	var pressed_something = false
	if ( Input.is_action_just_pressed("Action") ):
		pressed_clothing = rhythm_gameplay._perform_action("Space")
		pressed_something = true
	if ( Input.is_action_just_pressed("left") ):
		pressed_clothing =rhythm_gameplay._perform_action("A")
		pressed_something = true
	if ( Input.is_action_just_pressed("right") ):
		pressed_clothing = rhythm_gameplay._perform_action("D")
		pressed_something = true
	if ( Input.is_action_just_pressed("up") ):
		pressed_clothing =rhythm_gameplay._perform_action("W")
		pressed_something = true
	if ( Input.is_action_just_pressed("down") ):
		pressed_clothing = rhythm_gameplay._perform_action("S")
		pressed_something = true

	if ( !(pressed_clothing is bool) && pressed_clothing != 0 ):
		pressed_clothing = pressed_clothing - 1
		if ( clothing_click_order.find(pressed_clothing) == -1):
			var clothing_node = $LooseClothing.get_children()[pressed_clothing]
			clothing_node.visible = false
			clothing_click_order.append(pressed_clothing)
			equipped_clothes[pressed_clothing].visible = true
			equipped_clothes[pressed_clothing].z_index = clothing_click_order.size()

		if ( clothing_click_order.size() == equipped_clothes.size() ):
			var is_valid_order = true
			var underpants = clothing_click_order.find(0)
			var trousers = clothing_click_order.find(2)
			var shirt = clothing_click_order.find(3)
			var vest = clothing_click_order.find(4)
			var belt = clothing_click_order.find(5)

			is_valid_order = is_valid_order && trousers > underpants
			is_valid_order = is_valid_order && belt > trousers
			is_valid_order = is_valid_order && vest > shirt

			var tween = get_tree().create_tween()
			tween.tween_property( $Man, "position:x", $Man.position.x + 1200, 2)
			await tween.finished
			tween.kill()
			if ( is_valid_order ):
				$Success.visible = true
			else:
				$Failure.visible = true
	elif( pressed_something ):
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
