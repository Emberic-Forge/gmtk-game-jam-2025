extends BaseMiniGame

@onready var sequence = $Scene/Sequence

func play(_root : Root) -> void:
	sequence.play()
