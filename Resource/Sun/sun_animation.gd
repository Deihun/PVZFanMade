extends Node2D

var click_callbacks: Array[Callable] = []

@export_category("Visual Property")
@export var size : float = 1.0
@export var auto_start : bool = true
@export var click_to_collect : bool = true
@export_enum("default", "blue", "red") var color : String = "default"

var canBecollected : bool = true


func _ready() -> void:
	scale *= size
	if !auto_start: $AnimationPlayer.stop()
	if !click_to_collect: _remove_access_to_collect()
	match color:
		"blue":
			modulate = Color.AQUA
			pass
		"red":
			modulate = Color.BROWN
			pass
func _remove_access_to_collect() -> void:
	$SunOnClick.queue_free()


func _on_sun_on_click_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and canBecollected:
		canBecollected = false
		for callback in click_callbacks:
			if callback.is_valid():
				callback.call()
