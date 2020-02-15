tool
extends Node

var lazer_scene = preload("res://Stages/Lazer.tscn")

func post_import(scene):
	for node in scene.get_children():
		if node is TileMap:
			pass
		elif node is Node2D:
			for object in node.get_children():
				if object.name.begins_with("lazer"):
					var lazer = lazer_scene.instance()
					lazer.position = object.position + Vector2(16, 48)
					
					object.add_child(lazer)
					lazer.set_owner(scene)
	return scene
