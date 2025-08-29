extends Node2D  # main_holder_for_probability

@onready var group_ignore_this_nodes := [$overall,$entry]


var probability_pool: Array = []  # [{ "prob": float, "seed_packet": Node }]
@export var spawn_delay: float = 7.0
@export var max_active_packets: int = 8
@export var auto_start :=false

var _is_running := false
var _spawn_coroutine


func _ready() -> void:
	$overall.hide()
	read_all_state_object()

	if auto_start: start()


func read_all_state_object():
	probability_pool.clear()

	for child in get_children():
		if child in group_ignore_this_nodes: 
			continue

		var prob_val: float = child.probability_chance
		var seed_packet: Node = child.get_child(0)
		probability_pool.append({
			"prob": prob_val,
			"seed_packet": seed_packet.duplicate() # keep a copy
		})
		child.queue_free()



func start():
	$entry.play("start")
	#await get_tree().create_timer(1.0).timeout
	if _is_running:
		return
	_is_running = true
	spawn_loop() 


func stop():
	_is_running = false


func spawn_loop() -> void:
	
	await get_tree().create_timer(0.1).timeout 
	while _is_running:
		if $overall/Part_To_Be_Seen.get_child_count() >= max_active_packets:
			await get_tree().create_timer(0.5).timeout
			continue

		if probability_pool.is_empty():
			push_warning("No probability pool available to spawn from!")
			stop()
			return

		var chosen_seed = pick_random_seed()
		if chosen_seed:
			add_new_seed_packet(chosen_seed.duplicate())  
			print("getting seed")
		await get_tree().create_timer(spawn_delay).timeout


func pick_random_seed() -> Node:
	var total_weight: float = 0.0
	for entry in probability_pool:
		total_weight += entry.prob

	var rnd = randf() * total_weight
	var cumulative = 0.0
	for entry in probability_pool:
		cumulative += entry.prob
		if rnd <= cumulative:
			return entry.seed_packet
	return null


func add_new_seed_packet(node: Node):
	var dragger = load("res://HUD/borders/level_manager/drag_seed_packet_up.tscn").instantiate()
	$overall/Part_To_Be_Seen.add_child(dragger)
	dragger.position = Vector2.ZERO
	dragger.global_position = $overall/position_of_child_entering.global_position
	dragger.add_child(node)
	node.position = Vector2.ZERO
	node.mode = "one-time-used"
