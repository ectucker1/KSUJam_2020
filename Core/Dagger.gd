extends KinematicBody2D

const GRAVITY := 200.0

const THROW_SPEED := 350.0
const STOP_SCALE := 0.8

var enabled := true
var throw_direction := Vector2.ZERO

var velocity := Vector2.ZERO

func _ready():
	velocity = throw_direction * THROW_SPEED

func _physics_process(delta: float):
	# Apply gravity
	velocity.y += GRAVITY * delta
	if is_on_floor() && velocity.y > 0.0:
		velocity.y = 0.0
	
	# Actually move
	move_and_slide(velocity, Vector2.UP, true, 1, PI / 8, true)
	
	# Bounce and disable on hit
	if enabled:
		if get_slide_count() > 0:
			var collison = get_slide_collision(0)
			velocity = collison.normal * velocity.length()
			enabled = false
	
	# Slow down after bounce
	if not enabled:
		velocity.x *= STOP_SCALE
		if velocity.y < 0:
			velocity.y *= STOP_SCALE
