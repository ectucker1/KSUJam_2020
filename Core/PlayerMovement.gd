extends KinematicBody2D

const GRAVITY := 300.0

const GROUND_ACC := 300.0
const GROUND_DEC := 200.0

const AIR_ACC := 150.0
const AIR_DEC := 0.0

const MAX_SPEED := 70.0
const JUMP_SPEED = 200.0

const COYOTE_TIME = 0.1
const INPUT_RECALL_TIME = 0.1

var input_direction := Vector2.ZERO
var jump_last_pressed := INF

var velocity := Vector2.ZERO

var last_on_ground = 0.0

func _physics_process(delta: float):
	# Advance input timers
	jump_last_pressed += delta
	
	# Check ground
	var on_ground := is_on_floor()
	if on_ground:
		last_on_ground = 0.0
	else:
		last_on_ground += delta
	
	# Apply directional input
	if on_ground:
		velocity.x += input_direction.x * GROUND_ACC * delta
	else:
		velocity.x += input_direction.x * AIR_ACC * delta
	if abs(velocity.x) > MAX_SPEED:
		velocity.x = sign(velocity.x) * MAX_SPEED
	
	# Apply fake friction
	if input_direction.x == 0.0:
		var cur_sign = sign(velocity.x)
		if on_ground:
			velocity.x -= cur_sign * GROUND_DEC * delta
		else:
			velocity.x -= cur_sign * AIR_DEC * delta
		if sign(velocity.x) != cur_sign:
			velocity.x = 0.0
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	if on_ground && velocity.y > 0.0:
		velocity.y = 0.0
	
	# Jump code
	if jump_last_pressed < INPUT_RECALL_TIME && last_on_ground < COYOTE_TIME:
		velocity.y = -JUMP_SPEED
		jump_last_pressed = INF
	
	# Actually move
	move_and_slide(velocity, Vector2.UP, true, 4, PI / 4, true)

func _input(event):
	if event.is_action_pressed("move_right"):
		input_direction.x = 1
	if event.is_action_pressed("move_left"):
		input_direction.x = -1
	
	if event.is_action_released("move_right") && input_direction.x > 0:
		input_direction.x = 0
	if event.is_action_released("move_left") && input_direction.x < 0:
		input_direction.x = 0
	
	if event.is_action_pressed("move_jump"):
		jump_last_pressed = 0.0
