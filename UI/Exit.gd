extends Button

func _ready():
	connect("pressed", self, "exit")
	connect("mouse_entered", self, "hover")


func hover():
	$Click.play()

func exit():
	get_tree().quit()
