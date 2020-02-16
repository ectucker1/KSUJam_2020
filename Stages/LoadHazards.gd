tool
extends Node

var lazer_scene = preload("res://Stages/Lazer.tscn")

func post_import(scene):
	for node in scene.get_children():
		if node is TileMap:
			#var bounds = get_used_rect()
			pass
	return scene
