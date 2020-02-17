extends Button

export(String, FILE, "*.tscn,*.scn") var next

func _ready():
	connect("pressed", self, "exit")
	connect("mouse_entered", self, "hover")


func hover():
	$Click.play()

func exit():
	print("main")
	get_node("/root/Global/LevelMusic").stop()
	get_node("/root/Global/Fader").fade_to(next)
	get_parent().unpause()
