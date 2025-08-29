extends Node2D

@export var ground_y_position := 50.0  # The Y position to stop at (global Y)
@export var gravity := 600.0
@export var initial_force_min := Vector2(-100, -100)
@export var initial_force_max := Vector2(100, -200)
@export var horizontal_drag := 0.9  # To slow down X motion over time

var _velocity := Vector2.ZERO
var _target: Node2D
var _is_falling := true
var _has_initialized := false


func _ready():
	if get_parent() is Node2D:
		_target = get_parent()

		# Detach and preserve position
		var pos = _target.global_position
		get_tree().current_scene.add_child(_target)
		_target.set_as_top_level(true)
		_target.global_position = pos

		# Set initial velocity with random X force and upward Y force
		_velocity = Vector2(
			randf_range(initial_force_min.x, initial_force_max.x),
			randf_range(initial_force_min.y, initial_force_max.y)
		)

		_has_initialized = true
	else:
		push_error("This node must be added as a child of a Node2D.")


func _process(delta: float) -> void:
	if !_has_initialized or !_target or !_is_falling:
		return

	# Apply gravity
	_velocity.y += gravity * delta

	# Apply horizontal drag
	_velocity.x *= pow(horizontal_drag, delta * 60.0)

	# Move target
	_target.global_position += _velocity * delta

	# Stop falling if we hit the ground
	if _target.global_position.y >= ground_y_position:
		_target.global_position.y = ground_y_position
		_is_falling = false

		# Optional: wait before removing
		await get_tree().create_timer(3.0).timeout
		_target.queue_free()
