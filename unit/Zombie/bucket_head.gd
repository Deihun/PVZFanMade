extends Node2D

var hp := 1200
var only_trigger_once := false

func take_damage(value : int) -> int :
	var excess_damage = max(0,(value - hp))
	hp-= value
	check_for_damage_number()
	return excess_damage



func check_for_damage_number():
	if hp > 300 and hp < 500:
		$imagge.texture = load("res://unit/Zombie/basic_zombie/bucket_head_damage.png")
	elif hp > 0 and hp < 300:
		$imagge.texture = load("res://unit/Zombie/basic_zombie/bucket_head_lethal.png")
	elif hp <= 0 and !only_trigger_once:
		only_trigger_once = true
		var _global_position := self.global_position  
		var target := self.duplicate()
		self.position=Vector2(0,0)
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		self.top_level = false
		self.visible = false
		get_tree().current_scene.add_child(target)
		target.position = Vector2.ZERO
		target.global_position = _global_position
		behavior.disappear_after_3s =true
		target.add_child(behavior)
		await get_tree().create_timer(3).timeout
		queue_free()
