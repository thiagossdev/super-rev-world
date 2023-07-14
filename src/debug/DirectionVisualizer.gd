extends Node2D

const Colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}

const DEFAULT_THEME_WIDTH := 4
const MUL = 1

@export var character: CharacterBody2D
@export_range(1, 10) var width: int = DEFAULT_THEME_WIDTH
@export_range(0.0001, 100) var multiplier: float = 1
@export var redraw_time: float = 0.25

var parent = null
var redraw_timer = 0.0


func _ready():
	if character:
		set_process(true)
		queue_redraw()


func _process(delta):
	redraw_timer += delta
	if redraw_timer > redraw_time:
		redraw_timer = 0
		queue_redraw()


func _draw():
	if character:
		RenderingServer.canvas_item_clear(get_canvas_item())
		draw_vector(character.velocity, Vector2.ZERO, Colors.BLUE)
		draw_vector(character.get_real_velocity(), Vector2.ZERO, Colors.PINK)


func draw_vector(vector, offset, color):
	if vector == Vector2.ZERO:
		return

	draw_line(offset * multiplier, vector * multiplier, color, width)
	draw_arc(offset, 3 * width, 0, TAU, 24, color, width)
	draw_triangle_equilateral(vector * multiplier, vector.normalized(), 10, color)


func draw_triangle_equilateral(
	center = Vector2(), direction = Vector2(), radius = 50, color = Color.WHITE
):
	var size = max(float(width) / DEFAULT_THEME_WIDTH, 0.35)
	var vertices = [
		center + direction * radius * size,
		center + direction.rotated(2 * PI / 3) * radius * size,
		center + direction.rotated(4 * PI / 3) * radius * size,
	]
	draw_polygon(vertices, [color])
