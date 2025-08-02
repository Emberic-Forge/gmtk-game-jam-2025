extends BaseMiniGame

@onready var rhythm_prototype : RhythmPrototype = $RhythmPrototype

func play(root : Root) -> void:
	rhythm_prototype.initialize(root)
