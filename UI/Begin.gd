extends Button

export(String, FILE, "*.tscn,*.scn") var next

func _ready():
	connect("pressed", self, "begin")
	connect("mouse_entered", self, "hover")


func hover():
	$Click.play()

func begin():
	get_tree().change_scene(next)
