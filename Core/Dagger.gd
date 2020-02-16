extends KinematicBody2D

const GRAVITY := 500.0

const THROW_SPEED := 400.0
const STOP_SCALE := 0.4
const MIN_SPEED = 5.0
const MIN_COLLISION_SPACING = 0.15

var enabled := true
var throw_direction := Vector2.ZERO

var grav_dir := 1.0

var velocity := Vector2.ZERO

var last_collison := INF

func _ready():
	velocity = throw_direction * THROW_SPEED

func _physics_process(delta: float):
	last_collison += delta
	
	# Apply gravity
	velocity.y += GRAVITY * delta * grav_dir
	if is_on_floor() and velocity.y > 0.0:
		velocity.y = 0.0
	
	# Stop when velocity is slow enough
	if velocity.length() < MIN_SPEED:
		velocity = Vector2.ZERO
	
	# Allow for moving platforms
	if is_on_floor():
		velocity += get_floor_velocity()
	
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
			if last_collison > MIN_COLLISION_SPACING:
				$Effects/Bounce.play()
				get_node("/root/Global/Shaker").shake(0.2, Vector2(2, 2), Vector2(60, 50))
			$Sprite/AnimationPlayer.play("Dead")
			last_collison = 0.0

func _input(event):
	if event.is_action_pressed("move_flip") and enabled:
		grav_dir *= -1.0
		$Effects/Flip.play()
