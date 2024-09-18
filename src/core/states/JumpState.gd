class_name JumpState
extends CharacterState

@export var jump_force: float = 672.0
@export var speed: float = 512.0
@export var acceleration: float = 8.0
@onready var fall_state: String = "fall"
@onready var idle_state: String = "idle"
@onready var walk_state: String = "walk"
@onready var run_state: String = "run"
@onready var dash_state: String = "dash"


func enter():
	super()
	actor.velocity.y = -jump_force


func physics_process(delta):
	var direction = get_direction()

	if direction < 0:
		actor._sprite.flip_h = true
	elif direction > 0:
		actor._sprite.flip_h = false

	actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, direction * speed, acceleration)
	actor.move_and_slide()

	if actor.velocity.y > 0:
		change_state(fall_state)
		return

	if actor.is_on_floor():
		if direction:
			change_state(walk_state)
		else:
			change_state(idle_state)


func get_direction():
	return Input.get_axis("move_left", "move_right")
