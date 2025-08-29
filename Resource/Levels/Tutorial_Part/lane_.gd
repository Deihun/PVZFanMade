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

@export_enum("lane1","lane2","lane3","lane4","lane5","lane6","lane7") var lane_collision_layer : String="lane1"
@onready var spawn_position := $zombie_spawn_area
@onready var physic_body_interaction := $physics_body_interaction

#func _on_untargettable_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("spawn_protection"):body.remove_from_group("spawn_protection")

func _ready() -> void:
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
