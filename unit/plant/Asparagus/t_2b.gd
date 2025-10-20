extends Area2D

var damage = 4
var threshhold_limit = 100

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("zombie"): return
	var hpManagement = body.get_node("zombie_hp_management")
	if hpManagement: 
		if hpManagement.current_health > threshhold_limit: hpManagement.take_damage(damage, null)
