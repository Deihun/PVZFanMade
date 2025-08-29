extends HBoxContainer 
@export_file("*.tscn") var progress_bar_wave_scene 
@export var main_camera : Node
@export_category("When About to Start Properties")
@export_range(1.0,60.0) var delay_before_game_start := 20.0
@export var on_start := false
@export var allow_to_trigger_immediately := false
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
	await get_tree().create_timer(0.3).timeout
	check_if_win()

func _ready() -> void:
	set_process(false)
	#Engine.time_scale = 3.0
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

var play_once := false
func _play():
	if play_once: return
	play_once = true
	await get_tree().create_timer(delay_before_game_start).timeout
	progress_bar_wave = load(progress_bar_wave_scene).instantiate()
	for node in get_tree().current_scene.get_children():
		if node is Camera2D:
			progress_bar_wave.position = Vector2.ZERO
			node.add_child(progress_bar_wave)
			progress_bar_wave.global_position = Vector2.ZERO
			#progress_bar_wave.position = Vector2.ZERO
	add_child(progress_bar_wave)
	total_waves = max(1, get_child_count()-2)
	var step_percent : float = 100.0 / total_waves
	
	var wave_index := -1
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
	await get_tree().process_frame  
	var next_wave = get_child(0)
	if next_wave: 
		if next_wave.has_method("start_this_wave"): next_wave.start_this_wave()
		else: play_queue_next()
	

func wave_completed():
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
	if zombie_group.size()<=0 and get_child_count()<=0: 
		if final_as_reward: final_as_reward.visible = true
