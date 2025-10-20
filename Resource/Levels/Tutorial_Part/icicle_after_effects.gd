extends Node2D

var damage = 10
var master

func _ready() -> void:
	$"2".rotate(randf_range(0,360))


func _on__hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var get_max := body.get_node("zombie_hp_management")
		var movement := body.get_node("zombie_movement_management")
		if get_max: get_max.take_damage(damage,master)
		if movement : movement.apply_chill(5.0,0.9)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
