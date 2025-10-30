extends Node
@export var speed: float = 500.0
@export var turn_speed: float = 5.0

var _parent: Node2D
var _camera: Camera2D

func _ready() -> void:
	_parent = get_parent() as Node2D
	_camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	if not _parent or not _camera:
		return

	var target_pos = _camera.get_global_mouse_position()
	var dir = (target_pos - _parent.global_position).normalized()
	var target_angle = dir.angle()

	_parent.rotation = lerp_angle(_parent.rotation, target_angle, turn_speed * delta)

	_parent.global_position += Vector2.RIGHT.rotated(_parent.rotation) * speed * delta
