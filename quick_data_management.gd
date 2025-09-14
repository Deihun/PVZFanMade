extends Node # Autoload

@onready var plant_information := $plant_information
@onready var savemanager := $save_manager
@onready var global_calls_manager := $global_call_manager
@onready var common_called_method := $common_called_methods
@onready var sound_manager := $sound_manager

var sun : int = 300
var zombie_killed : int = 0
var plant_killed : int = 0
var plant_deployed : int = 0

var _sun_bank_position : Vector2 = Vector2.ZERO
var _evolution_bank_position := Vector2.ZERO
var location_where_evolutionUI_place : Vector2
var mode_normal_selection

var _selected_data_in_seed_packet : Control 
var _selected_plant_node_as_icon : Node2D





func _input(event: InputEvent) -> void: 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var tile = get_tile_under_mouse()

		if tile:
			if _selected_plant_node_as_icon:
				if _selected_plant_node_as_icon.name.begins_with("shovel"):
					if tile.has_method("remove_top_plant"):
						tile.remove_top_plant()
					_remove_plant_for_queue_plant()
				elif _selected_plant_node_as_icon.name.begins_with("power"):
					if tile.has_method("power_occupied_tile"):
						tile.power_occupied_tile()
					_remove_plant_for_queue_plant()
				elif _selected_data_in_seed_packet:
					if tile.has_method("plant_on_this_tile"):
						tile.plant_on_this_tile(_selected_data_in_seed_packet)
					_remove_plant_for_queue_plant()
		else:
			_remove_plant_for_queue_plant()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed: 
		_remove_plant_for_queue_plant()



func get_tile_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var scene_root = get_tree().current_scene
	if not scene_root:
		return null

	var space_state = scene_root.get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space_state.intersect_point(query, 32)
	for hit in result:
		if hit.collider.is_in_group("plant_tile"):
			return hit.collider
	return null


func get_seedpacket_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var scene_root = get_tree().current_scene

	if scene_root:
		var space_state = scene_root.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_pos
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result = space_state.intersect_point(query, 32)
		for hit in result:
			if hit.collider.is_in_group("seed_packet"):
				return hit.collider
	
	for control in get_tree().get_nodes_in_group("seed_packet"):
		if control is Control:
			if control.get_global_rect().has_point(mouse_pos):
				return control
	
	return null



func _process(delta: float) -> void:
	if _selected_plant_node_as_icon:
		_selected_plant_node_as_icon.global_position = get_viewport().get_mouse_position()

func _select_plant_to_boost():
	_remove_plant_for_queue_plant()
	var evolution_icon = Sprite2D.new()
	get_tree().current_scene.add_child(evolution_icon)
	evolution_icon.name = "evolve"
	evolution_icon.texture = load("res://HUD/EvolutionUI/evolve_power_boost.png")
	evolution_icon.z_index = 101
	_selected_plant_node_as_icon = evolution_icon

func _add_plant_for_queue_plant(seed_packet : Control, animation_node:Node2D):
	var selected_plant = animation_node
	get_tree().current_scene.add_child(selected_plant)
	_selected_plant_node_as_icon = selected_plant
	_selected_data_in_seed_packet = seed_packet
	if seed_packet.has_method("selected_as_object"): seed_packet.selected_as_object(true)

func _add_object_for_queue(cursor_attachment:Node2D, master:Control= null):
	var selected_object = cursor_attachment
	get_tree().current_scene.add_child(selected_object)
	if master: 
		_selected_data_in_seed_packet= master
		if _selected_data_in_seed_packet.has_method("selected_as_object"): _selected_data_in_seed_packet.selected_as_object(true)
	_selected_plant_node_as_icon = selected_object



func _remove_plant_for_queue_plant(value : bool = false):
	if _selected_data_in_seed_packet: if _selected_data_in_seed_packet.has_method("selected_as_object"): _selected_data_in_seed_packet.selected_as_object()
	if _selected_plant_node_as_icon:
		_selected_plant_node_as_icon.queue_free()
		_selected_plant_node_as_icon = null
	if not value:
		_selected_data_in_seed_packet = null

var _value_of_last_collected_sun = 0
func change_sun_value(_sun : int) -> void:
	sun = _sun
	global_calls_manager.when_sun_value_change_trigger()

func add_sun(value : int = 25):
	change_sun_value(sun + value)
	_value_of_last_collected_sun = value
	global_calls_manager.when_sun_collected_trigger()

func _reset_all_data()->void:
	sun = 50
	zombie_killed = 0
	plant_killed = 0
	plant_deployed = 0



var evolution_power_point := 0
func gain_evolution_power_point() -> bool:
	if evolution_power_point >= 4:
		return false
	evolution_power_point += 1
	global_calls_manager.plant_boost_value_change_trigger()
	return true

func get_evolution_power() -> bool:
	if evolution_power_point > 0:
		evolution_power_point -= 1
		global_calls_manager.plant_boost_value_change_trigger()
		return true
	global_calls_manager.plant_boost_value_change_trigger()
	return false
