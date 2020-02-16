extends Node

var time := 0.0

var time_left := 0.0
var frequency = Vector2.ZERO
var intensity = Vector2.ZERO

var offset

func _process(delta):
	time += delta
	time_left -= delta
	if time_left > 0.0:
		offset = Vector2(intensity.x * sin(time * frequency.x), intensity.y * sin(time * frequency.y))
	else:
		offset = Vector2.ZERO

func shake(time: float, intensity: Vector2, frequency: Vector2):
	if self.time_left < 0.0:
		self.time = 0.0
	self.time_left = max(time_left, time)
	self.intensity = Vector2(max(intensity.x, self.intensity.x), max(intensity.y, self.intensity.y))
	self.frequency = Vector2(max(frequency.x, self.frequency.x), max(frequency.y, self.frequency.y))
