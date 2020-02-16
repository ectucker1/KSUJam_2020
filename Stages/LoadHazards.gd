tool
extends Node

var lazer_scene = preload("res://Stages/Lazer.tscn")

func post_import(scene):
	for node in scene.get_children():
		if node is TileMap:
			var bounds = node.get_used_rect()
			node.add_to_group("map")
			node.set_meta("start", bounds.position * 32.0 + Vector2(0.0, 32.0))
			node.set_meta("end", bounds.end * 32.0 - Vector2(0.0, 32.0))
	return scene
