extends ColorRect

var next := ""

func fade_to(path):
	next = path
	$AnimationPlayer.play("FadeTo")

func next():
	get_tree().change_scene(next)
