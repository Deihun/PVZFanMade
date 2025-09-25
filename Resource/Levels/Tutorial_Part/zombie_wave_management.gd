extends HBoxContainer 
@export_file("*.tscn") var progress_bar_wave_scene 
@export var main_camera : Node
@export_category("When About to Start Properties")
@export_range(1.0,60.0) var delay_before_game_start := 20.0
@export var on_start := false
@export var allow_to_trigger_immediately := false
@export var game_reward_music : AudioStream
@export var final_as_reward : Node
@export_category("Vector position for ZombieSpawner")
@export var lane_1 : Node2D
@export var lane_2 : Node2D
@export var lane_3 : Node2D
@export var lane_4 : Node2D
@export var lane_5 : Node2D
@export var lane_6 : Node2D
@export var lane_7 : Node2D


@export var allow_six_lane := false
@export var allow_seven_lane := false

var total_waves := 0
var completed_waves := 0
var progress_bar_wave
var big_wave_percentages := []

func _process(delta: float) -> void:
	check_if_win()

func _ready() -> void:
	set_process(false)
	progress_bar_wave = load(progress_bar_wave_scene).instantiate()
	for node in get_tree().current_scene.get_children():
		if node is Camera2D:
			progress_bar_wave.position = Vector2.ZERO
			node.add_child(progress_bar_wave)
			progress_bar_wave.global_position = Vector2.ZERO
			break
	for child in get_children():
		if !child.has_method("start_this_wave"): continue
		child.lane_1_node = lane_1
		child.lane_2_node = lane_2
		child.lane_3_node = lane_3
		child.lane_4_node = lane_4
		child.lane_5_node = lane_5
		child.lane_6_node = lane_6
		child.lane_7_node = lane_7
	if final_as_reward: final_as_reward.visible = false
	if on_start: _play()
	if main_camera: main_camera.when_starting_callable.append(Callable(self,"_play"))
	await get_tree().create_timer(0.5).timeout
	place_all_zombie_as_preview()

var play_once := false
func _play():
	if play_once: return
	play_once = true
	for _zombie in preview_zombies_node: 
		if _zombie: _zombie.queue_free()
		else: preview_zombies.erase(_zombie)
	await get_tree().create_timer(delay_before_game_start).timeout
	QuickDataManagement.sound_manager.play_high_priority_audio(load("res://HUD/borders/level_manager/wave_sfx.mp3"))
	progress_bar_wave.start_wave()
	total_waves = max(1, get_child_count()-2)
	var step_percent : float = 100.0 / total_waves
	
	var wave_index := 0
	for wave in get_children():
		if !wave.has_method("start_this_wave"): continue
		wave_index += 1
		if  wave._mark_as_big_wave:
			var percent = step_percent * wave_index
			big_wave_percentages.append(percent)
			progress_bar_wave.spawn_flag_at_progress(percent)
	play_queue_next()

func play_queue_next():
	var wave = get_child(0)
	wave.queue_free()
	if !is_inside_tree(): return
	await get_tree().process_frame  #this line causes an error if i interrupt the scene like either changing the scene or quiting the game
	var next_wave = get_child(0)
	if next_wave: 
		if next_wave.has_method("start_this_wave"): next_wave.start_this_wave()
		else: play_queue_next()
	

func wave_progress():
	completed_waves += 1
	var percent : float = (float(completed_waves) / float(total_waves)) * 100.0
	progress_bar_wave.set_progress(percent)

var zombie_group: Array[Node2D] = []
func add_new_zombie_for_overall(zombie : Node2D):
	zombie_group.append(zombie)
	zombie.tree_exited.connect(_if_zombie_die.bind(zombie))

func _if_zombie_die(node: Node2D):
	zombie_group.erase(node)
	set_process(true)

func check_if_win():
	if get_child_count() <= 0 and QuickDataManagement._amount_of_current_zombie_in_board.size() <= 0:
		final_as_reward.show()
		QuickDataManagement.sound_manager.play_music(game_reward_music,false)
		set_process(false)




@export var collision_where_zombie_is_place_preview:CollisionShape2D
var preview_zombies = []
var preview_zombies_node = []

func add_this_zombie(instance_path : String):
	preview_zombies.append(instance_path)

func place_all_zombie_as_preview() -> void:
	if !collision_where_zombie_is_place_preview:return
	var zombie_count : Dictionary = {}
	for path in preview_zombies:
		var zombie_scene := load(path)
		if zombie_scene == null:
			continue
		var zombie = zombie_scene.instantiate()

		if not zombie_count.has(path):
			get_tree().current_scene.add_child(zombie)
			preview_zombies_node.append(zombie)
			zombie.z_index = 2
			zombie.y_sort_enabled =true
			zombie_count[path] = 0
		else:
			get_tree().current_scene.add_child(zombie)
			preview_zombies_node.append(zombie)
			zombie.z_index = 2
			zombie.y_sort_enabled =true
			zombie_count[path] += 1
			if  zombie_count[path] >= 5:
				zombie_count[path] = 0
			else:
				zombie.queue_free()
				preview_zombies_node.erase(zombie)


		var shape = collision_where_zombie_is_place_preview.shape
		var pos := collision_where_zombie_is_place_preview.global_position
		
		if shape is RectangleShape2D:
			var extents = shape.extents
			var local_x = randf_range(-extents.x, extents.x)
			var local_y = randf_range(-extents.y, extents.y)
			zombie.global_position = pos + Vector2(local_x, local_y)
		elif shape is CircleShape2D:
			var r = shape.radius
			var angle = randf() * TAU
			var dist = randf() * r
			var local_offset = Vector2(cos(angle), sin(angle)) * dist
			zombie.global_position = pos + local_offset
		else:
			zombie.global_position = pos

		if zombie.has_method("_set_as_idle"):
			zombie._set_as_idle()
		else:
			zombie.queue_free()
