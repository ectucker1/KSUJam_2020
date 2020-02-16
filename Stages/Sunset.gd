extends Node2D

export(String, FILE, "*.tscn,*.scn") var next

func _ready():
	get_node("/root/Global/LevelMusic").stop()

func transition():
	print("transition")
	get_node("/root/Global/Fader").fade_to(next)
