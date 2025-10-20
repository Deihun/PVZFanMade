extends CharacterBody2D

var devouring_duration : int = 45
var amount_of_zombies_i_can_eat : int = 1
var amount_of_zombies_im_chewing : int = 0

func _ready() -> void:
	add_to_group("plant")
	$ChomperAnimation.i_spawn()
	$ChomperAnimation._chomper_on_attack = Callable(self,"bite_zombies")
	$ChomperAnimation._i_already_ate_that_zombie = Callable(self,"successful_devour")
	$EvolutionSenderSupportBehavior.tier1A_callable=Callable(self,"_tier1A")
	$EvolutionSenderSupportBehavior.tier2A_callable=Callable(self,"_tier2A")
	$EvolutionSenderSupportBehavior.tier3A_callable=Callable(self,"_tier3A")
	$EvolutionSenderSupportBehavior.tier1B_callable=Callable(self,"_tier1B")
	$EvolutionSenderSupportBehavior.tier2B_callable=Callable(self,"_tier2B")
	$EvolutionSenderSupportBehavior.tier3B_callable=Callable(self,"_tier3B")

func _process(delta: float) -> void:
	if $Detection_Area.zombies_inside.size() > 0 and amount_of_zombies_im_chewing < amount_of_zombies_i_can_eat: $ChomperAnimation.trigger_attack()

func bite_zombies()->void:
	if $Detection_Area.zombies_inside.is_empty(): return
	var closest_zombie = null
	var closest_dist = INF
	for zombie in $Detection_Area.zombies_inside:
		if !is_instance_valid(zombie):
			continue
		var dist = global_position.distance_to(zombie.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_zombie = zombie
	if closest_zombie:
		if closest_zombie.is_in_group("giant") or closest_zombie.is_in_group("testing"):
			pass #bite damage instead
		else: 
			var closes_has_power = closest_zombie.get_node("PowerBoostDrop")
			if closes_has_power:
				var powerboost = load("res://HUD/EvolutionUI/EvolutionPowerBoost.tscn").instantiate()
				get_tree().current_scene.add_child(powerboost)
				powerboost.global_position = global_position
				powerboost.z_index = 100
			closest_zombie.queue_free()
			amount_of_zombies_im_chewing += 1
			$ChomperAnimation.i_devour_zombie()
			start_chew_zombie_timer()
	_spit_goo()


func start_chew_zombie_timer()-> void:
	var timer : Timer = Timer.new()
	timer.wait_time = devouring_duration
	timer.autostart = false
	timer.one_shot= true
	add_child(timer)
	timer.timeout.connect(func():
		amount_of_zombies_im_chewing -= 1
		$ChomperAnimation.i_completely_gulp_a_zombie()
		timer.queue_free()
		)
	timer.start()

func successful_devour()-> void:
	$EvolutionSenderSupportBehavior.increase_progress_evolution(100.0)
	_devour_t2b()
	_devour_t3b()

func _tier1A():
	$ChomperAnimation.t1a()
	devouring_duration -= 7
func _tier2A():
	$ChomperAnimation.t2a()
func _tier3A():
	amount_of_zombies_i_can_eat += 1
	$ChomperAnimation.t3a()
func _tier1B():
	$PlantDamageNodeManager.damage += 250
	$ChomperAnimation.t1b()
func _tier2B():
	$ChomperAnimation.t2b()
func _tier3B():
	$ChomperAnimation.t3b()

var _first_time_im_trigger = true
func _devour_t2b() -> void:
	if !$EvolutionSenderSupportBehavior._tier2b_obtain: return
	if $EvolutionSenderSupportBehavior._tier1b_obtain: $plant_health_management_behaviour.heal_maxhealth_percentage(10.0)
	else: $plant_health_management_behaviour.heal(100)
	if _first_time_im_trigger: 
		_first_time_im_trigger = false
		var bonus_health = 50 if $EvolutionSenderSupportBehavior._tier1b_obtain else 100
		$plant_health_management_behaviour.gain_extra_max_health(bonus_health)

func _devour_t3b() -> void:
	if !$EvolutionSenderSupportBehavior._tier3b_obtain: return
	$plant_health_management_behaviour.gain_extra_max_health(45)

var can_spit_goo := true


func _spit_goo() -> void:
	if !$EvolutionSenderSupportBehavior._tier2a_obtain or !can_spit_goo: return
	can_spit_goo = false
	$time_for_goo.start()
	var i = 0
	for zombie in $Detection_Area.zombies_inside:
		if !zombie: continue
		var goo := preload("res://unit/plant/Chomper/goo.tscn").instantiate()
		goo.slowdown_fraction = 0.5 if $EvolutionSenderSupportBehavior._tier1b_obtain else 0.3
		goo.amount_of_time_before_i_disappear = 75 if $EvolutionSenderSupportBehavior._tier1a_obtain else 15
		get_tree().current_scene.add_child(goo)
		goo.global_position = zombie.global_position + Vector2(0,-10)
		i += 1
		if i >= 4: break
	var goo := preload("res://unit/plant/Chomper/goo.tscn").instantiate()
	goo.slowdown_fraction = 0.5 if $EvolutionSenderSupportBehavior._tier1b_obtain else 0.3
	goo.amount_of_time_before_i_disappear = 75 if $EvolutionSenderSupportBehavior._tier1a_obtain else 15
	get_tree().current_scene.add_child(goo)
	goo.global_position = global_position + Vector2(randf_range(300,500),0)
	


func _on_time_for_goo_timeout() -> void:
	can_spit_goo = true
