extends Control

@export var _outer_radius : int = 256
@export var inner_radius : int = 64
@export var line_width : float = 2.0

@export var base_colors: Array[Color] = [
	Color(0.8, 0.3, 0.3, 0.5), # default alpha = 0.5
	Color(0.3, 0.8, 0.3, 0.5),
	Color(0.3, 0.3, 0.8, 0.5)
]

# Fixed 3 callables
@export var option_1: Callable
@export var option_2: Callable
@export var option_3: Callable

var _pressed: bool = false
var _hover_slice: int = -1  # -1 = none

func _ready():
	print("i appear")
	mouse_filter = Control.MOUSE_FILTER_STOP
	grab_focus()
	set_process_input(true)

func _draw() -> void:
	var angle_per = PI / 3.0  # semi-circle split into 3 slices
	
	for i in range(3):
		var start_angle = PI + i * angle_per
		var end_angle = start_angle + angle_per
		
		var col = base_colors[i]
		if i == _hover_slice and _pressed:
			col.a = 1.0  # highlight
		
		_draw_arc_slice(Vector2.ZERO, _outer_radius, inner_radius, start_angle, end_angle, col)
		
		# Outlines
		draw_arc(Vector2.ZERO, _outer_radius, start_angle, end_angle, 32, Color.BLACK, line_width)
		draw_arc(Vector2.ZERO, inner_radius, start_angle, end_angle, 32, Color.BLACK, line_width)

func _draw_arc_slice(center: Vector2, outer_r: float, inner_r: float, start_angle: float, end_angle: float, color: Color) -> void:
	var points: PackedVector2Array = []
	var resolution = 24
	
	# Outer arc
	for j in range(resolution + 1):
		var t = lerp(start_angle, end_angle, float(j) / resolution)
		points.append(center + Vector2(cos(t), sin(t)) * outer_r)
	
	# Inner arc (reverse)
	for j in range(resolution, -1, -1):
		var t = lerp(start_angle, end_angle, float(j) / resolution)
		points.append(center + Vector2(cos(t), sin(t)) * inner_r)
	
	draw_polygon(points, [color])

func _process(delta: float) -> void:
	if _pressed:
		_update_hover_slice(get_local_mouse_position())
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pressed = true
			_update_hover_slice(event.position)
		else:
			if _pressed:
				_pressed = false
				_handle_release()
				queue_free()

func _update_hover_slice(mouse_pos: Vector2) -> void:
	_hover_slice = -1
	var pos = mouse_pos - size / 2
	var dist = pos.length()
	if dist < inner_radius or dist > _outer_radius:
		return
	
	var angle = atan2(pos.y, pos.x)
	if angle < 0: angle += TAU
	if angle < PI or angle > TAU:  # not in top semicircle
		return
	
	_hover_slice = int(floor((angle - PI) / (PI / 3.0)))

func _handle_release() -> void:
	match _hover_slice:
		0: if option_1.is_valid(): 
			option_1.call()
			print("1")
		1: if option_2.is_valid(): option_2.call()
		2: if option_3.is_valid(): option_3.call()
