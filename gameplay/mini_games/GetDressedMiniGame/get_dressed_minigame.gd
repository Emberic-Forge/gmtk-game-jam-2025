extends BaseMiniGame
const NOTES := "notes"

@onready var rhythm_gameplay : RhythmGameplay = $RhythmGameplay
@onready var man : Sprite2D = $Man

var next_clothes_press_time
var clothes_press_order = []
var root : Root
var clothing_click_order = []
var equipped_clothes = []
var clothes_labels = []

var map : Dictionary
var successfull_presses : Array[Dictionary]

signal press_something
signal press_succeeded
signal press_failed

func _ready():
	equipped_clothes = $Man.get_children()
	for equipped_clothing in equipped_clothes:
		equipped_clothing.visible = false

	press_something.connect(_shake_sprite)




func play(root : Root, map_path : String) -> void:
	self.root = root
	map = RhythmComposer.load_from_file(map_path)
	press_succeeded.connect(root.increment_process)
	press_failed.connect(root.loose_life)
	root.on_next_mini_game.connect(reset)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_pressed():
		press_something.emit()
		for note in map[NOTES]:
			var key = note.keys()[0]
			var timing = note.values()[0]
			if event.is_action(key):
				if rhythm_gameplay._perform_action(key, note):
					press_succeeded.emit()
					successfull_presses.append({key : timing})
				else:
					press_failed.emit()

	pass

func _process( delta ):
	var music_player := root.get_music_player()
	for note in map[NOTES]:
		var key = note.keys()[0]
		var timing = note.values()[0]
		if is_note_missed(key,timing, rhythm_gameplay.success_timing):
			press_failed.emit()

func is_note_missed(incoming_key : String, timing : float, success_timings : float) -> bool:
	var music_player := root.get_music_player()
	var missed_timing := timing < (music_player.get_playback_position() + success_timings)
	var has_not_being_pressed := true

	for data in successfull_presses:
		var key = data.keys()[0]
		if incoming_key == key and data[key] == timing:
			has_not_being_pressed = false
			break
	return missed_timing and has_not_being_pressed

func reset() -> void:
	successfull_presses.clear()
	map.clear()

	#var valid_press = false
	#var pressed_clothing = 0
	#var pressed_something = false
	#if ( Input.is_action_just_pressed("Action") ):
		#pressed_clothing = rhythm_gameplay._perform_action("Space")
		#pressed_something = true
	#if ( Input.is_action_just_pressed("left") ):
		#pressed_clothing =rhythm_gameplay._perform_action("A")
		#pressed_something = true
	#if ( Input.is_action_just_pressed("right") ):
		#pressed_clothing = rhythm_gameplay._perform_action("D")
		#pressed_something = true
	#if ( Input.is_action_just_pressed("up") ):
		#pressed_clothing =rhythm_gameplay._perform_action("W")
		#pressed_something = true
	#if ( Input.is_action_just_pressed("down") ):
		#pressed_clothing = rhythm_gameplay._perform_action("S")
		#pressed_something = true
#
	#if ( !(pressed_clothing is bool) && pressed_clothing != 0 ):
		#pressed_clothing = pressed_clothing - 1
		#if ( clothing_click_order.find(pressed_clothing) == -1):
			#var clothing_node = $LooseClothing.get_children()[pressed_clothing]
			#clothing_node.visible = false
			#clothing_click_order.append(pressed_clothing)
			#equipped_clothes[pressed_clothing].visible = true
			#equipped_clothes[pressed_clothing].z_index = clothing_click_order.size()
#
		#if ( clothing_click_order.size() == equipped_clothes.size() ):
			#var is_valid_order = true
			#var underpants = clothing_click_order.find(0)
			#var trousers = clothing_click_order.find(2)
			#var shirt = clothing_click_order.find(3)
			#var vest = clothing_click_order.find(4)
			#var belt = clothing_click_order.find(5)
#
			#is_valid_order = is_valid_order && trousers > underpants
			#is_valid_order = is_valid_order && belt > trousers
			#is_valid_order = is_valid_order && vest > shirt
#
			#var tween = get_tree().create_tween()
			#tween.tween_property( $Man, "position:x", $Man.position.x + 1200, 2)
			#await tween.finished
			#tween.kill()
			#if ( is_valid_order ):
				#$Success.visible = true
			#else:
				#$Failure.visible = true
	#elif( pressed_something ):
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
