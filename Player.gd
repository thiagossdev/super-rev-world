extends CharacterBody2D

# const SPEED = 2550.0
# const JUMP_VELOCITY = -2000.0
const SPEED = 512.0
const SPEED_IN_AIR = 512.0
const JUMP_VELOCITY = -672.0
const JUMP_WALL_PUSHBACK = 256.0

const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 64.0
const SLOPE_THRESHOLD = deg_to_rad(66)

const ACCELERATION = 8.0
const FRICTION_IN_FLOOR = 16.0
const FRICTION_IN_AIR = 20.0

const MAX_JUMPS = 3
const MAX_GEAR_VELOCITY_ERROR = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const WALL_SLIDE_GRAVITY = 100

@onready var _sprite = $Sprite
@onready var _camera = $Camera2D

@export var jump_buffer_time: float = 0.1
@export var max_gears: int = 3
@export var gear_time: float = 10
var gear_timer: float = 0
@export var min_wall_slide_time: float = 1.3
@export var max_wall_slide_time: float = 2.3
var wall_slide_timer: float = 0

var current_gear: int = 1

var current_jumps = 1
var speed: float = 0
var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var jump_buffer_timer: float = 0


func _init():
	floor_snap_length = SNAP_LENGTH
	floor_max_angle = SLOPE_THRESHOLD

	jump_buffer_timer = 0


func _physics_process(delta):
	var acceleration = ACCELERATION
	speed = current_gear * SPEED

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

		if not direction:
			velocity.x = move_toward(velocity.x, 0, FRICTION_IN_AIR)
			print("Frinction on AIR")
		elif abs(velocity.x) < SPEED_IN_AIR:
			acceleration += FRICTION_IN_FLOOR
			velocity.x = move_toward(velocity.x, direction * SPEED_IN_AIR, acceleration)

	else:
		acceleration += FRICTION_IN_FLOOR
		velocity.x = move_toward(velocity.x, 0, FRICTION_IN_FLOOR)

		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)

	process_jump(direction)
	process_wall_slide(delta)
	move_and_slide()
	process_gear(delta)


func get_direction() -> Vector2:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	return direction.normalized()


func is_jump_action() -> bool:
	return Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")


# func accelerate(direction):
# 	if is_on_floor():
# 		speed = min(speed + ACCELERATION, SPEED)
# 		velocity = velocity.move_toward(direction * speed, ACCELERATION)
# 	elif is_on_wall():
# 		speed = 0

# func add_friction(direction):
# 	# speed = 0
# 	if is_on_floor():
# 		speed = max(min(speed - FRICTION_IN_FLOOR, SPEED), 0)
# 		velocity = velocity.move_toward(Vector2.ZERO, FRICTION_IN_FLOOR)
# 	else:
# 		speed = max(min(speed - FRICTION_IN_AIR, SPEED), 0)
# 		velocity = velocity.move_toward(direction * -SPEED, FRICTION_IN_FLOOR)


func player_movement():
	move_and_slide()


func process_jump(direction):
	# Handle Jump.
	if is_jump_action():
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall() and direction:
			velocity.y = JUMP_VELOCITY
			velocity.x = -direction * JUMP_WALL_PUSHBACK

	# if Input.is_action_just_pressed("ui_up"):
	# 	if current_jumps < MAX_JUMPS:
	# 		velocity.y = JUMP_VELOCITY
	# 		current_jumps += 1
	# else:
	# 	velocity.y += gravity

	# if is_on_floor():
	# 	current_jumps = 1
	# if current_jumps >= MAX_JUMPS:
	# 	_sprite.rotation = deg_to_rad(
	# 		(
	# 			75
	# 			if (
	# 				(velocity.y < gravity * 7 and _sprite.flip_h)
	# 				or (velocity.y > gravity * 7 and not _sprite.flip_h)
	# 			)
	# 			else -75
	# 		)
	# 	)
	# else:
	# 	_sprite.rotation = 0


func process_wall_slide(delta):
	if not is_on_wall() or is_on_floor():
		wall_slide_timer = 0
		return

	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		wall_slide_timer = 0
		return

	if wall_slide_timer <= min_wall_slide_time:
		velocity.y = 0
	elif wall_slide_timer < max_wall_slide_time:
		velocity.y = min(velocity.y + WALL_SLIDE_GRAVITY * delta, WALL_SLIDE_GRAVITY)
	wall_slide_timer += delta


func process_gear(delta):
	var max_velocity_error = (current_gear - 1) * SPEED - MAX_GEAR_VELOCITY_ERROR
	var velocity_x = abs(velocity.x)
	if velocity_x < MAX_GEAR_VELOCITY_ERROR:
		current_gear = 1
		gear_timer = 0
		print("GEAR REST: " + str(current_gear))
	elif current_gear > 1 and velocity_x < max_velocity_error:
		current_gear -= 1
		gear_timer = 0
		print("GEAR DOWN: " + str(current_gear))
	elif current_gear < max_gears:
		if gear_timer == 0 or (abs(velocity_x - speed) >= MAX_GEAR_VELOCITY_ERROR):
			gear_timer = gear_time
			print("GEAR START TIMER (" + str(current_gear) + ")")
		elif gear_timer < 0:
			current_gear += 1
			gear_timer = 0
			print("GEAR UP: " + str(current_gear))
		else:
			gear_timer -= delta
			print("GEAR COUNTDOWN (" + str(current_gear) + "): " + str(gear_timer))
	else:
		print("MAX GEAR (" + str(current_gear) + ")")


func play_animation(direction):
	if direction.x > 0:
		_sprite.flip_h = false
		_camera.offset.x = min(_camera.offset.x + 5, 512)
	else:
		_sprite.flip_h = true
		_camera.offset.x = max(_camera.offset.x - 5, 256)
	_sprite.play("walk")


func stop_animation():
	_sprite.stop()
