extends Control

var load_path: String

func _ready():
	load_path = QuickDataManagement.common_called_method.next_in_line_scene
	print(load_path)
	ResourceLoader.load_threaded_request(load_path)
	_start_loading()

func _start_loading() -> void:
	await get_tree().create_timer(1.0).timeout
	await _finish_loading()

func _finish_loading() -> void:
	while ResourceLoader.load_threaded_get_status(load_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

	var resource = ResourceLoader.load_threaded_get(load_path)
	if resource:
		var scene = resource.instantiate()
		get_tree().root.add_child(scene)

		# cleanup old scene
		get_tree().current_scene.queue_free()
		get_tree().current_scene = scene
