extends Node2D
@onready var tile_column_1 := $Occupied_Tile
@onready var tile_column_2 :=$Occupied_Tile2
@onready var tile_column_3 := $Occupied_Tile3
@onready var tile_column_4 := $Occupied_Tile4
@onready var tile_column_5 := $Occupied_Tile5
@onready var tile_column_6 := $Occupied_Tile6
@onready var tile_column_7 := $Occupied_Tile7
@onready var tile_column_8 := $Occupied_Tile8
@onready var tile_column_9 := $Occupied_Tile9
@onready var tile_column_10 := $Occupied_Tile10
@onready var tile_column_11 := $Occupied_Tile11
@onready var tile_column_12 := $Occupied_Tile12
@onready var spawn_position := $zombie_spawn_area
@onready var physic_body_interaction := $physics_body_interaction


@export_enum("lane1","lane2","lane3","lane4","lane5","lane6","lane7") var lane_collision_layer : String="lane1"
@export_category("DISABLE PLANTING")
@export var _tile_column_1_disable := false
@export var _tile_column_2disable := false
@export var _tile_column_3_disable := false
@export var _tile_column_4_disable := false
@export var _tile_column_5_disable := false
@export var _tile_column_6_disable := false
@export var _tile_column_7_disable := false
@export var _tile_column_8_disable := false
@export var _tile_column_9_disable := false
@export var _tile_column_10_disable := false
@export var _tile_column_11_disable := false
@export var _tile_column_12_disable := false
@export_category("ZMOG APPLIED")
@export var _tile_column_1_zmog_applied := false
@export var _tile_column_2_zmog_applied := false
@export var _tile_column_3_zmog_applied := false
@export var _tile_column_4_zmog_applied := false
@export var _tile_column_5_zmog_applied := false
@export var _tile_column_6_zmog_applied := false
@export var _tile_column_7_zmog_applied := false
@export var _tile_column_8_zmog_applied := false
@export var _tile_column_9_zmog_applied := false
@export var _tile_column_10_zmog_applied := false
@export var _tile_column_11_zmog_applied := false
@export var _tile_column_12_zmog_applied := false

func handle_zmog_lanes()-> void:
	var disable_arrays : Array[bool] = [_tile_column_1_disable,
		_tile_column_2_zmog_applied,
		_tile_column_3_zmog_applied,
		_tile_column_4_zmog_applied,
		_tile_column_5_zmog_applied,
		_tile_column_6_zmog_applied,
		_tile_column_7_zmog_applied,
		_tile_column_8_zmog_applied,
		_tile_column_9_zmog_applied,
		_tile_column_10_zmog_applied,
		_tile_column_11_zmog_applied,
		_tile_column_12_zmog_applied]
	var index = 0
	for i in [$Occupied_Tile, $Occupied_Tile2, $Occupied_Tile3, $Occupied_Tile4, $Occupied_Tile5, $Occupied_Tile6, $Occupied_Tile7, $Occupied_Tile8, $Occupied_Tile9, $Occupied_Tile10, $Occupied_Tile11, $Occupied_Tile12]:
		if disable_arrays[index]: i._add_zmog()
		index += 1

func handles_disable()-> void:
	var disable_arrays : Array[bool] = [_tile_column_1_disable,
		_tile_column_2disable,
		_tile_column_3_disable,
		_tile_column_4_disable,
		_tile_column_5_disable,
		_tile_column_6_disable,
		_tile_column_7_disable,
		_tile_column_8_disable,
		_tile_column_9_disable,
		_tile_column_10_disable,
		_tile_column_11_disable,
		_tile_column_12_disable]
	var index = 0
	for i in [$Occupied_Tile, $Occupied_Tile2, $Occupied_Tile3, $Occupied_Tile4, $Occupied_Tile5, $Occupied_Tile6, $Occupied_Tile7, $Occupied_Tile8, $Occupied_Tile9, $Occupied_Tile10, $Occupied_Tile11, $Occupied_Tile12]:
		i.disable_planting = disable_arrays[index]
		index += 1

func _ready() -> void:
	handles_disable()
	handle_zmog_lanes()
	$plant_decoy.add_to_group("plant")
	match lane_collision_layer:
		"lane1":
			physic_body_interaction.collision_layer = 1 << 10
		"lane2":
			physic_body_interaction.collision_layer = 1 << 11
		"lane3":
			physic_body_interaction.collision_layer = 1 << 12
		"lane4":
			physic_body_interaction.collision_layer = 1 << 13
		"lane5":
			physic_body_interaction.collision_layer = 1 << 14
		"lane6":
			physic_body_interaction.collision_layer = 1 << 15
		"lane7":
			physic_body_interaction.collision_layer = 1 << 16


func _on_catch_projectiles_area_entered(area: Area2D) -> void:
	area.queue_free()

func _on_catch_projectiles_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_trigger_game_over_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and not body.is_in_group("testing") and not body.is_in_group("ignore"):
		var scene := get_tree().current_scene
		if scene:
			# Look for the first Camera2D in the current scene
			var camera := scene.get_node_or_null("main_camera")
			if camera == null:
				camera = scene.find_child("main_camera", true, false)
			if camera and camera is Camera2D:
				if camera.has_method("game_over"): camera.game_over(body)



func _on_untargettable_area_body_entered(body: Node2D) -> void:
	if !body.is_in_group("zombie"): return
	if !body.has_node("zmog_handler"): body.add_child(preload("res://Resource/Levels/background_assets/nightFogs/zmog_handler.tscn").instantiate())
	var zmog_handler = body.get_node("zmog_handler")
	zmog_handler.add_new_zmog(self)


func _on_untargettable_area_body_exited(body: Node2D) -> void:
	if !body.is_in_group("zombie"): return
	if !body.has_node("zmog_handler"): body.add_child(preload("res://Resource/Levels/background_assets/nightFogs/zmog_handler.tscn").instantiate())
	var zmog_handler = body.get_node("zmog_handler")
	zmog_handler.remove_zmog(self)
