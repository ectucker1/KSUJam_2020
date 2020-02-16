extends Area2D

export(String, FILE, "*.tscn,*.scn") var next

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Close")
		$Jingle.play()
		body.elevator(self)

func advance():
	get_node("/root/Global/Fader").fade_to(next)
