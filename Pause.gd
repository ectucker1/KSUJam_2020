extends Control


func pause():
	get_tree().paused = true
	$AnimationPlayer.play("Pause")

func unpause():
	get_tree().paused = false
	$AnimationPlayer.play("Unpause")

func _input(event):
	if get_tree().current_scene.name != "Title":
		if event.is_action_pressed("ui_cancel"):
			if not get_tree().paused:
				pause()
			else:
				unpause()
