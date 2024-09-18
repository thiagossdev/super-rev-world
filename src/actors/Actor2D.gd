class_name Actor2D
extends CharacterBody2D

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speeds := Vector2(512.0, -672.0)
@export var gravity: float = default_gravity


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
