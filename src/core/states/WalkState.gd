class_name WalkState
extends CharacterState

@export var speed: float = 512.0
@export var acceleration: float = 8.0
@onready var fall_state: String = "fall"
@onready var idle_state: String = "idle"
@onready var run_state: String = "run"
@onready var jump_state: String = "jump"
@onready var dash_state: String = "dash"


func input(_event):
	if Input.is_action_just_pressed("jump"):
		change_state(jump_state)

	if Input.is_action_just_pressed("dash"):
		change_state(dash_state)

	return null


func physics_process(delta):
	if !actor.is_on_floor():
		change_state(idle_state)
		return

	var direction = get_direction()
	if direction < 0:
		actor._sprite.flip_h = true
	elif direction > 0:
		actor._sprite.flip_h = false

	actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, direction * speed, acceleration)
	actor.move_and_slide()

	if direction == 0:
		change_state(idle_state)


func get_direction():
	return Input.get_axis("move_left", "move_right")
