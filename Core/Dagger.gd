extends KinematicBody2D

const GRAVITY := 500.0

const THROW_SPEED := 400.0
const STOP_SCALE := 0.4
const MIN_SPEED = 5.0

var enabled := true
var throw_direction := Vector2.ZERO

var grav_dir := 1.0

var velocity := Vector2.ZERO

func _ready():
	velocity = throw_direction * THROW_SPEED

func _physics_process(delta: float):
	# Apply gravity
	velocity.y += GRAVITY * delta * grav_dir
	if is_on_floor() and velocity.y > 0.0:
		velocity.y = 0.0
	
	# Actually move
	if velocity.length_squared() > 0:
		move_and_slide(velocity, Vector2.UP, true, 1, PI / 8, true)
		rotation = velocity.angle()
	
	# Bounce and disable on hit
	if velocity.length_squared() > 0:
		if get_slide_count() > 0:
			var collison = get_slide_collision(0)
			velocity = velocity.bounce(collison.normal)
			velocity *= STOP_SCALE
			enabled = false
			grav_dir = 1.0
			$Effects/Bounce.play()
			$Sprite/AnimationPlayer.play("Dead")
	
	# Stop when velocity is slow enough
	if velocity.length() < MIN_SPEED:
		velocity = Vector2.ZERO
	
	# Slow down after bounce
	#if not enabled:
		#velocity.x *= STOP_SCALE
		#if velocity.y < 0:
		#	velocity.y *= STOP_SCALE

func _input(event):
	if event.is_action_pressed("move_throw") and enabled:
		grav_dir *= -1.0
		$Effects/Flip.play()
