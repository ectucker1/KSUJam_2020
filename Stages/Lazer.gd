extends Node2D

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("player"):
		body.kill()

func _process(delta):
	$Sprite.region_rect.position += Vector2(0, 32 * delta)
	if not $Hum.playing:
		$Hum.play()
