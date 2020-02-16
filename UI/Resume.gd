extends Button

func _ready():
	connect("pressed", self, "resume")
	connect("mouse_entered", self, "hover")


func hover():
	$Click.play()

func resume():
	get_parent().unpause()
