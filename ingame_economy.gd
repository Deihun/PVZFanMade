extends Node

var sun : int = 50
var zombie_killed : int = 0
var plant_killed : int = 0
var plant_deployed : int = 0

var _stored_selected_plant : String
var _selected_plant_node_as_icon : Node2D

func get_plant(plant_name: String) -> PackedScene:
	var plant_on_animation : PackedScene
	match plant_name:
		"peashooter":
			plant_on_animation = load("res://unit/plant/peashooter/peashooter_animationn.tscn").instantiate()
	return plant_on_animation

func get_plant_seed_packet(plant_name: String) -> PackedScene:
	var seed_packet_plant = load("res://HUD/borders/seed_packet.tscn").instantiate()
	match plant_name:
		"peashooter":
			seed_packet_plant.plant_name = "peashooter"
			seed_packet_plant.cooldown = 10
			seed_packet_plant.suncost = 100
		"sunflower":
			seed_packet_plant.plant_name = "sunflower"
			seed_packet_plant.cooldown = 10
			seed_packet_plant.suncost = 50
	
	return seed_packet_plant


func _input(event: InputEvent) -> void:
	if _selected_plant_node_as_icon and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_remove_plant_as_idle_plant()

func _process(delta: float) -> void:
	if !_selected_plant_node_as_icon:
		return
	_selected_plant_node_as_icon.global_position = get_viewport().get_mouse_position()


func _add_plant_as_idle_plant(plant_name : String):
	var selected_plant = get_plant(plant_name)
	get_tree().current_scene.add_child(selected_plant)
	_selected_plant_node_as_icon = selected_plant


func _remove_plant_as_idle_plant():
	_selected_plant_node_as_icon.queue_free()
	_selected_plant_node_as_icon = null
	_stored_selected_plant = ""



func add_sun(value : int = 25):
	sun += value

func _reset_all_data()->void:
	sun = 50
	zombie_killed = 0
	plant_killed = 0
	plant_deployed = 0
