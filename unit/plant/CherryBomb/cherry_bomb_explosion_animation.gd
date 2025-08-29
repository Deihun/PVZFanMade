extends Node2D

var damage := 3000
var master


func explode():
	$cherry_bomb_animation_player.play("explode")

func _on_explosion_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		var hp=body.get_node("zombie_hp_management")
		if hp: 
			hp.last_death_function = "other"
			hp.take_damage(damage,master,false)


func _on_cherry_bomb_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="explode" : queue_free()
