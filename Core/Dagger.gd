extends KinematicBody2D

const GRAVITY := 200.0

const THROW_SPEED := 400.0
const STOP_SCALE := 0.8

var enabled := true
var throw_direction := Vector2.ZERO

var grav_dir := 1.0

var velocity := Vector2.ZERO

func _ready():
	velocity = throw_direction * THROW_SPEED

func _physics_process(delta: float):
	# Apply gravity
	velocity.y += GRAVITY * delta * grav_dir
	if is_on_floor() && velocity.y > 0.0:
		velocity.y = 0.0
	
	# Actually move
	move_and_slide(velocity, Vector2.UP, true, 1, PI / 8, true)
	rotation = velocity.angle()
	
	# Bounce and disable on hit
	if enabled:
		if get_slide_count() > 0:
			var collison = get_slide_collision(0)
			velocity = collison.normal * velocity.length()
			enabled = false
			grav_dir = 1.0
	
	# Slow down after bounce
	if not enabled:
		velocity.x *= STOP_SCALE
		if velocity.y < 0:
			velocity.y *= STOP_SCALE

func _input(event):
	if event.is_action_pressed("move_throw") and enabled:
		grav_dir *= -1.0
