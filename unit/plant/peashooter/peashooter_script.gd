extends CharacterBody2D
@onready var attack_timer_cooldown:Timer = $attack_cooldown
@export var pea_projectile : Node2D 

var _threepeater: Node2D
var repeater : Node2D
var current_tier : int = 0

var _chance_to_deals_trueDamage := 0.2

var _tierb2_stacks_number: float=0
var _t1a_t2b_damage := 0.0 
var _tierb2_max_stacks_requirement := 25.0
var _t1a_t2b_damage_stacks := 0.0

var big_pea_shot_counter : int = 0
var ignore_attack_bigshot_aftermath : bool = false

var on_attack_mode : bool = false
var attack_ready: bool = true

var plant_to_be_boost : int = 0


func get_pea():
	var pea = pea_projectile.duplicate()
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	var collision = pea.get_node("CollisionShape2D")
	collision.disabled =false
	mobility_script.auto_start = true
	pea.show()
	pea.add_to_group("ally_projectile")
	pea.add_to_group("flamable")
	get_tree().current_scene.add_child(pea)
	pea.global_position = $pea_spawn_location.global_position
	pea.add_child(mobility_script)
	pea.master=self
	return pea


func _process(delta: float) -> void:
	if big_pea_shot_counter >= _tierb2_max_stacks_requirement and on_attack_mode and !attack_ready:
				big_pea_shot_counter=0
				repeater._big_shot()
				ignore_attack_bigshot_aftermath = true
	elif on_attack_mode and attack_ready and !ignore_attack_bigshot_aftermath:
		if has_node("peashooter"): $peashooter.start_attacking()
		elif repeater: 
			repeater.start_attacking()
			big_pea_shot_counter+= 2
		elif _threepeater:
			_threepeater.start_attacking()
		attack_timer_cooldown.wait_time = $PlantDamageNodeManager.get_total_computed_bonus_speed(0.1)
		attack_ready = false
		attack_timer_cooldown.start()

func gain_evolution_progress():
	$EvolutionSenderSupportBehavior.increase_progress_evolution(1.0)

func _ready() -> void:
	add_to_group("plant")
	$PlantDamageNodeManager.when_i_kill_callable.append(Callable(self,"gain_evolution_progress"))
	$EvolutionSenderSupportBehavior.tier1A_callable=Callable(self,"_tier1A")
	$EvolutionSenderSupportBehavior.tier2A_callable=Callable(self,"_tier2A")
	$EvolutionSenderSupportBehavior.tier3A_callable=Callable(self,"_tier3A")
	$EvolutionSenderSupportBehavior.tier1B_callable=Callable(self,"_tier1B")
	$EvolutionSenderSupportBehavior.tier2B_callable=Callable(self,"_tier2B")
	$EvolutionSenderSupportBehavior.tier3B_callable=Callable(self,"_tier3B")
	
	$Detection_Area.on_enemy_entered_callable = Callable(self,"_attack_mode") 
	$Detection_Area.on_no_more_enemies_callable = Callable(self,"not_attack_mode")
	$peashooter.trigger_attack_method = Callable(self,"spawn_pea") 
	$peashooter._spawn()
	await get_tree().create_timer(0.6).timeout
	$Detection_Area/CollisionShape2D.disabled = false


func _attack_mode():
	var attac_speed : float = 1.0 + ($PlantDamageNodeManager.bonus_attackspeed * 100.0)
	on_attack_mode = true
	if has_node("peashooter"): $peashooter.attack_animation_speed = 0.009 * $PlantDamageNodeManager.bonus_attackspeed
	elif repeater: repeater.attack_animation_speed = 0.3 * $PlantDamageNodeManager.bonus_attackspeed
	elif _threepeater: _threepeater.attack_animation_speed = 0.4 * $PlantDamageNodeManager.bonus_attackspeed


func not_attack_mode():
	on_attack_mode = false


func spawn_pea():
	var pea = get_pea()
	if randf_range(0.0,1.0) < _chance_to_deals_trueDamage and $EvolutionSenderSupportBehavior._tier1a_obtain: pea.true_damage = true
	pea.damage = $PlantDamageNodeManager.get_computed_damage()
	pea.master=self
	if $EvolutionSenderSupportBehavior._tier2b_obtain:
		$tier2B_stacks_expiration.stop()
		$tier2B_stacks_expiration.start()
		_tierb2_stacks_number = _tierb2_stacks_number+5 if _tierb2_stacks_number < _tierb2_max_stacks_requirement else _tierb2_stacks_number
		$PlantDamageNodeManager.bonus_attackspeed += 5 if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0
		$PlantDamageNodeManager.bonus_damage += _t1a_t2b_damage if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0
		_t1a_t2b_damage_stacks = _t1a_t2b_damage if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0

func spawn_big_pea():
	var pea = get_pea()
	if $EvolutionSenderSupportBehavior._tier1a_obtain: pea.true_damage = true
	pea.global_position = $pea_spawn_location.global_position
	pea.damage = $PlantDamageNodeManager.damage *5
	pea.master = self
	pea.scale = Vector2(3,3)
	get_parent().add_child(pea)
	$attack_cooldown.stop()
	$attack_cooldown.start()

func spawn_three_pea():
	var damage = $PlantDamageNodeManager.get_computed_damage()
	var set_to_true_damage = false
	if randf_range(0.0,1.0) < _chance_to_deals_trueDamage and $EvolutionSenderSupportBehavior._tier1a_obtain: set_to_true_damage = true
	var pea = get_pea()
	var second_pea = get_pea()
	var third_pea = get_pea()
	pea.true_damage = set_to_true_damage
	second_pea.true_damage = set_to_true_damage
	third_pea.true_damage = set_to_true_damage
	pea.damage = damage
	second_pea.damage = damage
	third_pea.damage = damage
	var first_behaviour_up = load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	var second_behaviour_up = load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	var third_behaviour_up = load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	first_behaviour_up.travel_limit_enable = true
	first_behaviour_up.auto_start=true
	first_behaviour_up.travel_limit_value = 8
	first_behaviour_up.direction = "DOWN"
	second_behaviour_up.travel_limit_enable = true
	second_behaviour_up.auto_start=true
	second_behaviour_up.travel_limit_value = 20
	second_behaviour_up.direction = "UP"
	third_behaviour_up.travel_limit_enable = true
	third_behaviour_up.auto_start=true
	third_behaviour_up.travel_limit_value = 35
	third_behaviour_up.direction = "DOWN"
	pea.add_child(first_behaviour_up)
	second_pea.add_child(second_behaviour_up)
	third_pea.add_child(third_behaviour_up)
	
	if $EvolutionSenderSupportBehavior._tier1b_obtain:
		$tier2B_stacks_expiration.stop()
		$tier2B_stacks_expiration.start()
		_tierb2_stacks_number+=5 if _tierb2_stacks_number <_tierb2_max_stacks_requirement else 0
		$PlantDamageNodeManager.bonus_attackspeed += 5 if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0
		$PlantDamageNodeManager.bonus_damage += _t1a_t2b_damage if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0
		_t1a_t2b_damage_stacks = _t1a_t2b_damage if _tierb2_stacks_number < _tierb2_max_stacks_requirement else 0

func _continue_normal_attack():
	ignore_attack_bigshot_aftermath = false

func _on_attack_cooldown_timeout() -> void:
	if ignore_attack_bigshot_aftermath: return
	attack_ready = true

func _on_tier_2b_stacks_expiration_timeout() -> void:
	$PlantDamageNodeManager.bonus_attackspeed -= _tierb2_stacks_number
	_tierb2_stacks_number = 0



func _tier1A():
	$peashooter._tier1A()
	$PlantDamageNodeManager.damage += 2
func _tier2A():
	plant_to_be_boost = 8
	_chance_to_deals_trueDamage = 0.5
	if $EvolutionSenderSupportBehavior._tier1b_obtain: $plant_attackspeed/CollisionShape2D.disabled=false
	$peashooter._tier2A()
	$PlantBoost/CollisionShape2D.disabled = false
func _tier3A():
	var _repeater = load("res://unit/plant/peashooter/repeater_animation.tscn").instantiate()
	add_child(_repeater)
	_repeater.global_position = $peashooter.global_position
	repeater = _repeater
	$peashooter.queue_free()
	repeater.trigger_attack_method = Callable(self,"spawn_pea") 
	repeater.trigger_big_attack = Callable(self,"spawn_big_pea")
	repeater.done_animating = Callable(self,"_continue_normal_attack")


func _tier1B():
	$PlantDamageNodeManager.bonus_attackspeed += 5
	$peashooter._tier1B()
func _tier2B():
	$peashooter._tier2B()
	if $EvolutionSenderSupportBehavior._tier1a_obtain: _t1a_t2b_damage=1.0
	if $EvolutionSenderSupportBehavior._tier1b_obtain: _tierb2_max_stacks_requirement = 40.0
func _tier3B():
	var threepeater = load("res://unit/plant/peashooter/threepeater.tscn").instantiate()
	add_child(threepeater)
	threepeater.global_position = $peashooter.global_position
	_threepeater = threepeater
	$peashooter.queue_free()
	_threepeater.trigger_attack_method = Callable(self,"spawn_three_pea") 
	$pea_spawn_location.position = Vector2(36.0,-55.0)
	var frstCopy_collision = $Detection_Area/CollisionShape2D.duplicate()
	var secndcopy = $Detection_Area/CollisionShape2D.duplicate()
	frstCopy_collision.position.y -= 120
	secndcopy.position.y += 120
	$Detection_Area.add_child(frstCopy_collision)
	$Detection_Area.add_child(secndcopy)




func _on_plant_boost_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant"):
		if plant_to_be_boost <= 0: return
		if plant_to_be_boost > 5: $Tier2A_indicator/PeashooterBuffReceivedVisual.texture=load("res://unit/plant/peashooter/peashooter_buff_received_visual.png")
		elif plant_to_be_boost >= 2 and plant_to_be_boost < 5: $Tier2A_indicator/PeashooterBuffReceivedVisual.texture=load("res://unit/plant/peashooter/peashooter_buff_received_visual_abouttoDeplete.png")
		elif plant_to_be_boost < 2 and plant_to_be_boost > 0:$Tier2A_indicator/PeashooterBuffReceivedVisual.texture=load("res://unit/plant/peashooter/peashooter_buff_received_visual_last.png")
		$Tier2A_indicator/plant.play("play")
		var evolution_manager = body.get_node("EvolutionSenderSupportBehavior")
		var evolution_buff_visualeffect = load("res://unit/plant/peashooter/tier_2a_peashooter_buff.tscn").instantiate()
		evolution_manager.boost_plants_percentage(0.35)
		body.add_child(evolution_buff_visualeffect)
		plant_to_be_boost -= 1


func _on_plant_attackspeed_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant"):
		if body.has_node("PlantDamageNodeManager"):
			var damage_handler = body.get_node("PlantDamageNodeManager")
			damage_handler.bonus_attackspeed += 2


func set_dictionary_stats(): 
	var stats_dictionary ={
		"Kill": $PlantDamageNodeManager.kill_count,
		"Damage": $PlantDamageNodeManager.damage,
		"BonusAttackSpeed": $PlantDamageNodeManager.bonus_attackspeed
	}
	$EvolutionSenderSupportBehavior.stats = stats_dictionary.duplicate()
