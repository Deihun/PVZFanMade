extends Node

var can_be_trigger = true
var amount_of_that_ice_pea_attack := 0

func receive_attack()-> bool:
	if !can_be_trigger: return false
	amount_of_that_ice_pea_attack += 1
	_change_appearance()
	if amount_of_that_ice_pea_attack == 6: 
		amount_of_that_ice_pea_attack =0
		can_be_trigger = false
		$cooldown.start()
		return true
	return false

func _change_appearance() -> void:
	var texture 
	match amount_of_that_ice_pea_attack:
		0: texture = load("res://unit/plant/SnowPea/t2b_stack_assets/no_stack.png")
		1: texture =  load("res://unit/plant/SnowPea/t2b_stack_assets/1.png")
		2: texture =  load("res://unit/plant/SnowPea/t2b_stack_assets/2_stack.png")
		3: texture =  load("res://unit/plant/SnowPea/t2b_stack_assets/3_stack.png")
		4: texture =  load("res://unit/plant/SnowPea/t2b_stack_assets/4_stack.png")
		5: texture =  load("res://unit/plant/SnowPea/t2b_stack_assets/fullstack.png")
	$NoStack.texture = texture
	$NoStack.visible = can_be_trigger


func _on_cooldown_timeout() -> void:
	can_be_trigger = true
