extends Control

@export var next_scene_path: String = "res://scenes/Level1.tscn"

var load_id

func _ready():
	load_id = ResourceLoader.load_threaded_request(QuickDataManagement.common_called_method.next_in_line_scene)
	_start_loading()

func _start_loading() -> void:
	await get_tree().create_timer(1.0).timeout  # ensure min 1s delay
	await _finish_loading()

func _finish_loading() -> void:
	while ResourceLoader.load_threaded_get_status(load_id) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

	var resource = ResourceLoader.load_threaded_get(load_id)
	var scene = resource.instantiate()

	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = scene
