extends Node2D

@export var animation_node:Node2D #this is reference correctly
@export var adjusted_height_spawn_started : int = 200
@export var adjusted_wave_will_go_to : int = 200
@export var water_surface_vfx_scale : Vector2 = Vector2(1.0,1.0)

var tide_original_position : Vector2
var animation_node_current_position
var already_in_water := false

func _ready() -> void:
	tide_original_position = $AnimatedSprite2D.position


func set_tides(how_fast_submerging := 0.5) -> void:
	if already_in_water: return
	already_in_water=true
	$AnimatedSprite2D.show()
	animation_node_current_position = animation_node.global_position
	$AnimatedSprite2D/Node2D.scale = water_surface_vfx_scale
	$AnimatedSprite2D.global_position = animation_node_current_position + Vector2(0, adjusted_height_spawn_started)	
	var old_parent = animation_node.get_parent()
	if old_parent: old_parent.remove_child(animation_node)
	$AnimatedSprite2D/visible_zombies.add_child(animation_node)
	animation_node.global_position = animation_node_current_position
	var tween = create_tween()
	tween.parallel().tween_property(animation_node, "position", Vector2(animation_node.position.x,(animation_node.position.y+adjusted_wave_will_go_to)), how_fast_submerging)
	tween.parallel().tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x, $AnimatedSprite2D.position.y - (adjusted_wave_will_go_to*0.5)), how_fast_submerging)

func unsubmerging(how_fast_submerging := 0.5) -> void:
	if !already_in_water: return
	already_in_water=false
	var tween = create_tween()
	tween.parallel().tween_property(animation_node, "position", Vector2(animation_node.position.x,(animation_node.position.y-adjusted_wave_will_go_to)), how_fast_submerging)
	tween.parallel().tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x,$AnimatedSprite2D.position.y + (adjusted_wave_will_go_to*0.5)) , how_fast_submerging)
	await get_tree().create_timer(how_fast_submerging).timeout
	animation_node_current_position = animation_node.global_position
	animation_node.get_parent().remove_child(animation_node)
	get_parent().add_child(animation_node)
	$AnimatedSprite2D.hide()
	animation_node.global_position = animation_node_current_position
