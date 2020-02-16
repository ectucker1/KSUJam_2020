extends KinematicBody2D

const SPEED := 32.0

export var dist := Vector2(0.0, 64.0)

onready var tween := get_node("Tween")

var start_pos := Vector2.ZERO

func _ready():
	start_pos = position
	tween_down()

func _process(delta):
	if not $Drone.playing:
		$Drone.play()

func tween_down():
	tween.interpolate_property(self, "position",
		start_pos, start_pos + dist, dist.length() / SPEED,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_callback(self, dist.length() / SPEED, "tween_up")
	tween.start()

func tween_up():
	tween.interpolate_property(self, "position",
		start_pos + dist, start_pos, dist.length() / SPEED,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_callback(self, dist.length() / SPEED, "tween_down")
	tween.start()
