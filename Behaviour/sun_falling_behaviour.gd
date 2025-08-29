extends Node2D

@export_category("Instantiation Connection")
@export var NormalMode_HUD_instance: Control # Reference the actual HUD instance, not the PackedScene
@export var sun_location_where_it_land: CollisionShape2D

@export_category("Sun Spawn Behaviour")
@export var sun_quality: int = 25
@export var spawn_height: float = -100.0
@export var cooldown_time: float = 15.0
@export var sun_scene: PackedScene = load("res://Resource/Sun/normal_sun.tscn")
@export var auto_start := false
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	if auto_start : start()

func start():
	var timer = Timer.new()
	timer.wait_time = cooldown_time
	timer.autostart = true
	timer.timeout.connect(_spawn_sun)
	add_child(timer)


func _spawn_sun():
	if !sun_location_where_it_land or !sun_scene:
		push_warning("ERROR: SunLocationShape or SunScene is missing")
		return

	var target_point = _get_random_point_inside_shape(sun_location_where_it_land)
	var spawn_position = Vector2(target_point.x, spawn_height)

	var sun = sun_scene.instantiate()
	add_child(sun)
	sun.global_position = spawn_position

	var tween = create_tween()
	tween.tween_property(sun, "global_position", target_point, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Connect or assign a callable for collection
	#if sun.has_method("_add_callable_on_sun"):
		#sun._add_callable_on_sun(func ():
			#_on_sun_collected(sun, tween)
		#)

func _on_sun_collected(sun: Node2D, _tween: Tween) -> void:
	QuickDataManagement.add_sun(sun_quality)
	var a = randf_range(0.5,0.8)
	_tween.stop()
	_tween.is_queued_for_deletion()
	NormalMode_HUD_instance.update_all_hud()
	var hud_target: Vector2 = NormalMode_HUD_instance.get_sun_when_claim_animation_position()

	var tween = create_tween()
	tween.tween_property(sun, "global_position", hud_target, a).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(a).timeout
	if is_instance_valid(sun):
		sun.queue_free()


func _get_random_point_inside_shape(shape_node: CollisionShape2D) -> Vector2:
	var shape = shape_node.shape
	if shape is RectangleShape2D:
		var x = rng.randf_range(-shape.extents.x, shape.extents.x)
		var y = rng.randf_range(-shape.extents.y, shape.extents.y)
		var local_point = Vector2(x, y)
		return shape_node.global_transform * local_point
	elif shape is CircleShape2D:
		while true:
			var point = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))
			if point.length_squared() <= 1.0:
				return shape_node.global_transform * (point * shape.radius)
	return shape_node.global_position
