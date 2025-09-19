extends Area2D
@onready var hold_progress: TextureProgressBar = $Node2D/progress

@export_category("Tile Settings")
@export var can_land_be_planted := true
@export var can_water_be_planted := false

var obstacles

var tile_ground_occupy
var tile_under_occupy
var tile_above_occupy

var press_time: float = 0.0
var is_holding: bool = false
const HOLD_THRESHOLD := 1.0
var hold_elapsed: float = 0.0


func plant_on_this_tile(seed_packet:Control):
	if obstacles:return
	if seed_packet.land_type and !can_land_be_planted: return 
	if !can_water_be_planted and seed_packet.water_type:return
	if tile_ground_occupy and seed_packet.land_type:
		var hp = tile_ground_occupy.get_node("plant_health_management_behaviour")
		if !hp:return
		if hp.plant_on_me(): QuickDataManagement.change_sun_value(QuickDataManagement.sun - seed_packet.suncost) 
		return
	if tile_under_occupy and seed_packet.can_be_planted_under:return
	$AudioStreamPlayer.stream = load("res://Behaviour/planting_sfx_1.mp3") if randi_range(1,2)==1 else load("res://Behaviour/planting_sfx_2.mp3")
	$AudioStreamPlayer.play()
	seed_packet.successfully_planted() 
	QuickDataManagement.change_sun_value(QuickDataManagement.sun - seed_packet.suncost) 
	var plant_node : Node2D = load(seed_packet.plant_tscn).instantiate()
	place_plant_without_cost(plant_node, seed_packet.take_tiles_space)
	QuickDataManagement._remove_plant_for_queue_plant() 
	if plant_node.has_node("plant_health_management_behaviour"):
		var hp = plant_node.get_node("plant_health_management_behaviour")
		hp._my_seed_packet = seed_packet


func place_plant_without_cost(node:Node2D, occupy_tile:= true):
	node.z_index = 1
	get_tree().current_scene.add_child(node) 
	node.connect("tree_exited", _delete_data.bind(node)) 
	QuickDataManagement.global_calls_manager._plant_exist_in_game.append(node)
	if occupy_tile: tile_ground_occupy = node 
	node.global_position = global_position 


func power_occupied_tile()-> void:
	if !tile_ground_occupy: return
	var evolve_framework = tile_ground_occupy.get_node("EvolutionSenderSupportBehavior")
	if !evolve_framework:return
	if evolve_framework._can_evolve: return
	if evolve_framework._current_tier >= 3: return
	evolve_framework.receive_plant_power()
	QuickDataManagement.get_evolution_power()
	


func _delete_data(node : Node):
	tile_ground_occupy = null
	QuickDataManagement.global_calls_manager._plant_exist_in_game.erase(node)


func remove_top_plant():
	if tile_ground_occupy: tile_ground_occupy.queue_free()


func _ready() -> void:
	add_to_group("plant_tile")
	hold_progress.visible = false
	hold_progress.min_value = 0.0
	hold_progress.max_value = 100.0
	hold_progress.value = 0.0



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !QuickDataManagement.savemanager.tool_exist("powerbank"):
		return
	if !tile_ground_occupy: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_holding = true
			hold_elapsed = 0.0
		else:
			if is_holding:
				if hold_elapsed >= HOLD_THRESHOLD:
					_run_evolution_boarder()
					hold_progress.value = 0.0
				else:
					_on_short_click()
					hold_progress.value = 0.0
				is_holding = false
				hold_progress.visible = false
				


func _run_evolution_boarder() -> void:
	if !tile_ground_occupy: return
	var evolution_of_plant = tile_ground_occupy.get_node("EvolutionSenderSupportBehavior")
	if !evolution_of_plant: return
	var UI_placement_evolutionBoarder = _get_the_UI_placement_evolutionboarder()
	var array_list : Array[Control] = [evolution_of_plant._create_the_evolution_boarder()]
	UI_placement_evolutionBoarder.set_current_evolution_details(array_list)


func _on_short_click() -> void:
	pass



func _get_the_UI_placement_evolutionboarder()-> Control:
	var UI_placement_evolutionBoarder : Control = _get_node_prioritizing_camera().get_node("UI_placement_evolutionBoarder")
	if !UI_placement_evolutionBoarder:
		UI_placement_evolutionBoarder = load("res://HUD/EvolutionUI/Control_EvolutionDetails.tscn").instantiate()
		_get_node_prioritizing_camera().add_child(UI_placement_evolutionBoarder)
		UI_placement_evolutionBoarder.name = "UI_placement_evolutionBoarder"
		UI_placement_evolutionBoarder.position -= Vector2(940,450)
	return UI_placement_evolutionBoarder

func _get_node_prioritizing_camera()-> Node:
	var main_camera = get_tree().current_scene.get_node("main_camera")
	if main_camera: return main_camera
	return get_tree().current_scene 


func _process(delta: float) -> void:
	if is_holding:
		hold_elapsed += delta
		var percent = clamp(hold_elapsed / HOLD_THRESHOLD, 0.0, 1.0)
		if percent >= 0.25 and !hold_progress.visible:
			hold_progress.visible = true
		if hold_progress.visible:
			hold_progress.value = percent * 100.0
