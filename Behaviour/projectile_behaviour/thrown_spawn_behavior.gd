extends Node  # This is a behavior script to attach as a child
@export var disappear_after_3s : bool = false
@export var initial_speed: float = 300.0
@export_range(-90.0, 0.0, 1.0) var launch_angle_deg: float = -60.0
@export var gravity: float = 500.0

@export var max_distance: Vector2 = Vector2(300, 300)
@export var dead_zone_size: Vector2 = Vector2(64, 64)

var velocity: Vector2 = Vector2.ZERO
var stop_position: Vector2
var stopped: bool = false
var parent: Node2D

func _ready():
	if disappear_after_3s:$disappear.start()
	parent = get_parent() as Node2D
	if parent == null:
		push_warning("Arc behavior must be a child of a Node2D")
		set_process(false)
		return

	# Find a valid stop position outside the dead zone
	stop_position = generate_random_landing_position(parent.global_position)
	
	# Calculate launch direction
	var to_target = (stop_position - parent.global_position).normalized()
	velocity = to_target * initial_speed

	set_process(true)

func _process(delta):
	if stopped or parent == null:
		return

	velocity.y += gravity * delta
	parent.global_position += velocity * delta

	# Stop when passing or reaching the target Y or overshooting downward
	if (velocity.y > 0 and parent.global_position.y >= stop_position.y):
		parent.global_position.y = stop_position.y
		velocity = Vector2.ZERO
		stopped = true

# --- Helper Functions ---

func generate_random_landing_position(origin: Vector2) -> Vector2:
	var target: Vector2
	while true:
		# Random offset within max distance
		var offset = Vector2(
			randf_range(-max_distance.x, max_distance.x),
			randf_range(0, max_distance.y)
		)

		# Reject if inside dead zone
		if abs(offset.x) > dead_zone_size.x / 2 or abs(offset.y) > dead_zone_size.y / 2:
			target = origin + offset
			break

	return target


func _on_disappear_timeout() -> void:
	parent.queue_free()
