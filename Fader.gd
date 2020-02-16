extends ColorRect

var next_path := ""

func fade_to(path):
	next_path = path
	$AnimationPlayer.play("FadeTo")

func next():
	get_tree().change_scene(next_path)
	if get_tree().current_scene.name == "Title":
		get_node("/root/Global/Hints").visible = true
		get_node("/root/Global/Hints").get_node("AnimationPlayer").play("Begone")
