extends KinematicBody2D

const GRAVITY := 500.0

const GROUND_ACC := 70000.0
const GROUND_DEC := 40000.0

const AIR_ACC := 400.0
const AIR_DEC := 0.0

const MAX_SPEED := 170.0
const JUMP_SPEED = 300.0

const COYOTE_TIME = 0.1
const INPUT_RECALL_TIME = 0.1

var dagger_scene := preload("res://Core/Dagger.tscn")

var dagger: KinematicBody2D = null

onready var anim_tree := get_node("AnimationTree")
onready var anim_state = anim_tree["parameters/Movement/playback"]

var flipped := false
var input_direction := Vector2.ZERO

var jump_last_pressed := INF
var throw_last_pressed := INF
var recall_last_pressed := INF

var velocity := Vector2.ZERO

var on_ground := true
var last_on_ground := 0.0

var elevator: Node2D = null

func _ready():
	anim_tree.active = true
	anim_state.start("Idle")

func _process(delta):
	# Determine animation state
	if last_on_ground < COYOTE_TIME:
		if input_direction.x != 0.0:
			if anim_state.get_current_node() != "Run":
				anim_state.travel("Run")
		else:
			if anim_state.get_current_node() != "Idle":
				anim_state.travel("Idle")
	else:
		if anim_state.get_current_node() != "Air":
			anim_state.travel("Air")
	
	if elevator != null:
		if abs(elevator.global_position.x - global_position.x) > 0.5:
			input_direction.x = sign(elevator.global_position.x - global_position.x)
		else:
			input_direction.x = 0.0
			set_physics_process(false)
			anim_state.travel("Foward")
			global_position.y = elevator.get_node("Door").global_position.y + 9
			if has_node("Camera"):
				var cam = get_node("Camera")
				var temp_pos = cam.global_position
				remove_child(cam)
				get_parent().add_child(cam)
				cam.set_owner(get_parent())
				cam.global_position = temp_pos

func _physics_process(delta: float):
	# Advance input timers
	jump_last_pressed += delta
	throw_last_pressed += delta
	
	# Check ground
	on_ground = is_on_floor()
	if on_ground:
		if last_on_ground > 0.2:
			$Effects/Land.play()
		last_on_ground = 0.0
	else:
		last_on_ground += delta
	
	# Bump head
	if is_on_ceiling() and velocity.y < 0:
		velocity.y = 0.0
	
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
	if on_ground and velocity.y > 0.0:
		velocity.y = 0.0
	
	# Jump code
	if jump_last_pressed < INPUT_RECALL_TIME and last_on_ground < COYOTE_TIME:
		$Effects/Jump.play()
		velocity.y = -JUMP_SPEED
		jump_last_pressed = INF
	
	# Throwing time
	if throw_last_pressed < INPUT_RECALL_TIME:
		if dagger == null:
			anim_tree["parameters/Fire/active"] = true
			throw_last_pressed = INF
			jump_last_pressed = INF
			recall_last_pressed = INF
			input_direction = Vector2.ZERO
	
	# Recall dagger
	if recall_last_pressed < INPUT_RECALL_TIME:
		if dagger != null:
			dagger.queue_free()
			dagger = null
			get_node("Camera").current = true
			recall_last_pressed = INF
			$Effects/Recall.play()
	
	# Actually move
	move_and_slide(velocity, Vector2.UP, true, 4, PI / 4, true)

func fire_hand():
	dagger = dagger_scene.instance()
	dagger.throw_direction = (get_global_mouse_position() - $ArmSpawn.global_position).normalized()
	dagger.global_position = $ArmSpawn.global_position
	get_parent().add_child(dagger)
	dagger.get_node("Camera").current = true
	$Effects/Fire.play()

func _input(event):
	# If not currently controlling the dagger
	if dagger == null:
		if event.is_action_pressed("move_right"):
			input_direction.x = 1
			flipped = false
			$Sprite.position.x = 4.0
			$Sprite.scale.x = 1.0
		if event.is_action_pressed("move_left"):
			input_direction.x = -1
			flipped = true
			$Sprite.position.x = -4.0
			$Sprite.scale.x = -1.0
		
		if event.is_action_released("move_right") and input_direction.x > 0:
			input_direction.x = 0
		if event.is_action_released("move_left") and input_direction.x < 0:
			input_direction.x = 0
		
		if event.is_action_pressed("move_jump"):
			jump_last_pressed = 0.0
		
		if event.is_action_pressed("move_throw"):
			throw_last_pressed = 0.0
	else:
		if event.is_action_pressed("move_recall"):
			recall_last_pressed = 0.0
		
		if event.is_action_pressed("move_warp"):
			var offset = Vector2()
			for cast in dagger.get_node("OverlapCheck").get_children():
				cast.enabled = true
				cast.force_raycast_update()
				if cast.is_colliding():
					var point = cast.get_collision_point()
					offset += point - dagger.global_position
			global_position = dagger.global_position - Vector2(8 * sign(offset.y), 24 * sign(offset.y)) + offset
			#print(offset)
			dagger.queue_free()
			dagger = null
			velocity = Vector2.ZERO
			get_node("Camera").current = true
			$Effects/Warp.play()

func kill():
	if is_processing():
		anim_state.travel("Idle")
		$Sprite.self_modulate = Color.black
		$Effects/Death.play()
		$Light2D/AnimationPlayer.play("Die")
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func elevator(elevator: Node2D):
	set_process_input(false)
	self.elevator = elevator

func restart():
	get_tree().reload_current_scene()
