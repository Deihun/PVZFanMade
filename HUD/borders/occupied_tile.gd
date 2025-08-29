extends Area2D
@export_category("Tile Settings")
@export var can_land_be_planted := true
@export var can_water_be_planted := false

var obstacles

var tile_ground_occupy
var tile_under_occupy
var tile_above_occupy


func plant_on_this_tile(seed_packet:Control):
	if obstacles:return
	if seed_packet.land_type and !can_land_be_planted: return 
	if !can_water_be_planted and seed_packet.water_type:return
	if tile_ground_occupy and seed_packet.land_type:return
	if tile_under_occupy and seed_packet.can_be_planted_under:return
			#if not tile.tile_ground_occupy: 
	seed_packet.successfully_planted() 
	QuickDataManagement.change_sun_value(QuickDataManagement.sun - seed_packet.suncost) 
	var plant_node : Node2D = load(seed_packet.plant_tscn).instantiate()
	place_plant_without_cost(plant_node)
	QuickDataManagement._remove_plant_for_queue_plant() 


func place_plant_without_cost(node:Node2D):
	get_tree().current_scene.add_child(node) 
	node.connect("tree_exited", _delete_data.bind(node)) #edit ths later for other type
	QuickDataManagement.global_calls_manager._plant_exist_in_game.append(node)
	tile_ground_occupy = node 
	node.global_position = global_position 


func _delete_data(node : Node):
	tile_ground_occupy = null
	QuickDataManagement.global_calls_manager._plant_exist_in_game.erase(node)


func remove_top_plant():
	if tile_ground_occupy: tile_ground_occupy.queue_free()


func _ready() -> void:
	add_to_group("plant_tile")
