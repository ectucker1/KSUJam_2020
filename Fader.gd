extends ColorRect

var next_path := ""

func fade_to(path):
	next_path = path
	$AnimationPlayer.play("FadeTo")

func next():
	get_tree().change_scene(next_path)
