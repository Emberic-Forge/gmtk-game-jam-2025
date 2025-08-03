class_name Root extends Node2D

var mini_game : Array[BaseMiniGame]
var current_mini_game : int

func _ready() -> void:
	for child in get_children():
		if child is BaseMiniGame:
			mini_game.append(child)
			child.process_mode = Node.PROCESS_MODE_DISABLED

	start_mini_game(0)


func start_mini_game(mini_game_indx : int) -> void:
	print("[LOG][Root]: Started new mini game! %f" % mini_game_indx)
	var mini_game := mini_game[mini_game_indx]
	mini_game.process_mode = Node.PROCESS_MODE_INHERIT
	mini_game.play(self)

func goto_next_mini_game() -> void:
	current_mini_game += 1
	if current_mini_game >= mini_game.size():
		current_mini_game = 0
	start_mini_game(current_mini_game)
