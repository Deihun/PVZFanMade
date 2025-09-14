extends Panel

@export_range(0.0,120.0) var _delay_duration := 10.0 
@export var _trigger_next_wave_if_this_is_clear := false 
@export var _zombie_spawn_with_delay_in_between := false
@export_range(0.1,10.0) var _delay_interval_between_spawn := 0.5

@export_category("Big Wave")
@export var _mark_as_big_wave := false
@export var _automatically_spawn_basic_zombies := false
@export var _number_of_zombies_in_big_wave := 3

var stored_enemy := []

var lane_1_node : Node2D
var lane_2_node : Node2D
var lane_3_node : Node2D
var lane_4_node : Node2D
var lane_5_node : Node2D
var lane_6_node : Node2D
var lane_7_node : Node2D

var lane1_array := []
var lane2_array := []
var lane3_array := []
var lane4_array := []
var lane5_array := []
var lane6_array := []
var lane7_array := []

#func _process(delta: float) -> void:
	##if stored_enemy.size() > 0:
		###await get_tree().create_timer(0.25).timeout
		##var enemy = stored_enemy[0]
		##print(enemy.global_position)
	#print(stored_enemy)
func _ready() -> void:
	if _mark_as_big_wave:
		var flag_zombie = load("res://unit/Zombie/Flag_Zombie/FlagZombie.tscn").instantiate()
		flag_zombie.position =Vector2.ZERO
		flag_zombie.global_position =Vector2.ZERO
		_add_this_char_on_reserve_array(flag_zombie)
		if _automatically_spawn_basic_zombies and _number_of_zombies_in_big_wave > 0:
			var count := 0
			while count < _number_of_zombies_in_big_wave:
				count+=1
				var basic_zombie = load("res://unit/Zombie/basic_zombie/normal_basic_zombie.tscn").instantiate()
				basic_zombie.position =Vector2.ZERO
				basic_zombie.global_position =Vector2.ZERO
				_add_this_char_on_reserve_array(basic_zombie)

func start_this_wave():
	if _mark_as_big_wave: await get_tree().create_timer(3.0).timeout
	$spawn_next.wait_time = _delay_duration
	var _lane_overall = [
		{"lane": lane1_array, "pos": lane_1_node},
		{"lane": lane2_array, "pos": lane_2_node},
		{"lane": lane3_array, "pos": lane_3_node},
		{"lane": lane4_array, "pos": lane_4_node},
		{"lane": lane5_array, "pos": lane_5_node},
		{"lane": lane6_array, "pos": lane_6_node},
		{"lane": lane7_array, "pos": lane_7_node},
	]


	while _lane_overall.size() > 0:
		
		var lane_info = _lane_overall.pick_random()
		var lane_array : Array = lane_info["lane"]
		

		if lane_array.is_empty():
			_lane_overall.erase(lane_info)
			continue
		
		var idx := randi_range(0,lane_array.size()-1)
		var entry = lane_array[idx]
		var char_enemy: CharacterBody2D = entry[0]
		var carry_power_boost: bool = (entry[1] == 1)

		lane_array.remove_at(idx)

		get_tree().current_scene.add_child(char_enemy)
		if carry_power_boost: char_enemy.add_child(load("res://Behaviour/power_boost_drop.tscn").instantiate())
		char_enemy.global_position = lane_info.pos.spawn_position.global_position
		
		char_enemy.get_node("zombie_hp_management").lane_rigidbody_collision = lane_info.pos.physic_body_interaction
		char_enemy.z_index = 5
		char_enemy.visible = true
		get_parent().add_new_zombie_for_overall(char_enemy)
		#stored_enemy.append(char_enemy)


		if _zombie_spawn_with_delay_in_between: await get_tree().create_timer(_delay_interval_between_spawn).timeout
		if _trigger_next_wave_if_this_is_clear:     
			if char_enemy: 
				char_enemy.tree_exited.connect(
				Callable(self, "_on_enemy_removed").bind(char_enemy))
	$spawn_next.start()

func _on_enemy_removed(char_enemy : CharacterBody2D):
	stored_enemy.erase(char_enemy)
	if _trigger_next_wave_if_this_is_clear and stored_enemy.size() <= 0:
		get_parent().wave_completed()
		get_parent().play_queue_next()

func _add_this_char_on_reserve_array(body : Node2D, lane_number := 0):
	var _body = load(body.scene_file_path).instantiate()
	var _has_boost : int = 1 if (body.has_node("PowerBoostDrop")) else 0
	get_parent().add_this_zombie(body.scene_file_path)
	if body.is_inside_tree(): body.get_parent().remove_child(body)
	body.queue_free()
	if lane_number == 0: lane_number = randi_range(1,5)#STILL STATIC 1-5, add later a random lane managementnumbers
	match lane_number:
		1:
			lane1_array.append([_body,_has_boost])
		2:
			lane2_array.append([_body,_has_boost])
		3:
			lane3_array.append([_body,_has_boost])
		4:
			lane4_array.append([_body,_has_boost])
		5:
			lane5_array.append([_body,_has_boost])

func _on_random__body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body)


func _on_lane_1_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body,1)



func _on_lane_2_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body,2)


func _on_lane_3_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body,3)


func _on_lane_4_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body,4)


func _on_lane_5_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body,5)


func _on_lane_6_body_entered(body: Node2D) -> void: 
	_add_this_char_on_reserve_array(body)


func _on_lane_7_body_entered(body: Node2D) -> void:
	_add_this_char_on_reserve_array(body)


func _on_spawn_next_timeout() -> void:
	get_parent().wave_completed()
	get_parent().play_queue_next()
