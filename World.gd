extends Node2D

@onready var player = $Player
@onready var velocity: Label = $CanvasLayer/Velocity
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	update_hud()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_hud():
	await timer.timeout
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), 0)
	velocity.text = (
		"Velocity: "
		+ str(player.get_real_velocity().length())
		+ "\n X: "
		+ str(player.get_real_velocity().x)
		+ "\n Y: "
		+ str(player.get_real_velocity().y)
		+ "\nDirection: ("
		+ str(direction.x)
		+ ","
		+ str(direction.y)
		+ ")"
	)
	update_hud()
