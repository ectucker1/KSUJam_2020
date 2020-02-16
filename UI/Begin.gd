extends Button

export(String, FILE, "*.tscn,*.scn") var next

func _ready():
	connect("pressed", self, "begin")
	connect("mouse_entered", self, "hover")


func hover():
	$Click.play()

func begin():
	get_node("/root/Global/Fader").fade_to(next)
	get_node("/root/Global/LevelMusic").play()
	get_node("../../../TitleMusic").stop()
