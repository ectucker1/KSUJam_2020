extends Camera2D

onready var shaker = get_node("/root/Global/Shaker")

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var map = get_tree().root.find_node("Tile Layer 1", true, false)
	if map.has_meta("start"):
		limit_left = map.get_meta("start").x
		limit_top = map.get_meta("start").y
	if map.has_meta("end"):
		limit_right = map.get_meta("end").x
		limit_bottom = map.get_meta("end").y

func _process(delta):
	offset = shaker.offset
