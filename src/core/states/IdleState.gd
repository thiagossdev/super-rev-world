class_name IdleState
extends CharacterState

@onready var fall_state: String = "fall"
@onready var walk_state: String = "walk"
@onready var run_state: String = "run"
@onready var jump_state: String = "jump"
@onready var dash_state: String = "dash"


func enter() -> void:
	super()
	actor.velocity.x = 0


func input(_event):
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		change_state(walk_state)
	elif Input.is_action_just_pressed("jump"):
		change_state(jump_state)


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()

	if !actor.is_on_floor():
		change_state(fall_state)
