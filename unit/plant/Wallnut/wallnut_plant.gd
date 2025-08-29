extends Node2D

var _receive_dammage_once := false
var _can_heal := false

func _ready() -> void:
	add_to_group("plant")
	$plant_health_management_behaviour._add_health_threshold_condition(func(): _when_health_damage(),70, 5)
	$plant_health_management_behaviour._add_health_threshold_condition(func(): _when_health_lethal(),35, 4)
	$plant_health_management_behaviour._when_shield_broken.append(Callable(self,"_destroy_shield_as_visual"))
	$plant_health_management_behaviour._taking_damage.append(Callable(self,"_start_evolution"))
	$EvolutionSenderSupportBehavior.tier1A_callable= Callable(self,"tier1a")
	$EvolutionSenderSupportBehavior.tier2A_callable= Callable(self,"tier2a")
	$EvolutionSenderSupportBehavior.tier3A_callable= Callable(self,"tier3a")
	$EvolutionSenderSupportBehavior.tier1B_callable= Callable(self,"tier1b")
	$EvolutionSenderSupportBehavior.tier2B_callable= Callable(self,"tier2b")
	$EvolutionSenderSupportBehavior.tier3B_callable= Callable(self,"tier3b")
	$Wallnut._spawn()

func tier1a():
	$plant_health_management_behaviour.gain_extra_max_health(500)
func tier2a():
	$Wallnut.set_to_tallnutt()
	$plant_health_management_behaviour.heal_maxhealth_percentage(100)
func tier3a():
	$plant_health_management_behaviour.gain_extra_max_health_baseOn_maxhealth(10)
	$plant_health_management_behaviour._taking_damage.append(Callable(self,"_when_taking_damage_heal_start"))

func tier1b():
	$plant_health_management_behaviour.gain_armor(2)
func tier2b():
	$WallnutEmpowerBehind.visible = true
	$Tier_2BEmpower/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.5).timeout
	$Tier_2BEmpower/CollisionShape2D.disabled = true

func tier3b():
	$plant_health_management_behaviour._taking_damage.append(Callable(self,"_when_taking_damage_gain_shield"))

func _when_health_damage():
	$Wallnut._trigger_damage_animation()

func _when_health_lethal():
	$Wallnut._trigger_lethal_animation()

func _start_evolution():
	if _receive_dammage_once: return
	$starts_evolution_when_progress.start()
	_receive_dammage_once = true

func _on_starts_evolution_when_progress_timeout() -> void:
	$EvolutionSenderSupportBehavior.increase_progress_evolution(1)

func _when_taking_damage_heal_start():
	_can_heal = false
	$heal_cooldown.stop()
	$heal_cooldown.start()

func _on_healing_per_sec_timeout() -> void:
	if _can_heal: $plant_health_management_behaviour.heal_maxhealth_percentage(10)


func _on_heal_cooldown_timeout() -> void:
	_can_heal = true

func _when_taking_damage_gain_shield():
	$Shield_Timer.stop()
	$Shield_Timer.start()

func _on_shield_timer_timeout() -> void:
	$Wallnut.set_shield_visible(true)
	$plant_health_management_behaviour.gain_shield($plant_health_management_behaviour.max_health * 0.05)

func _destroy_shield_as_visual():
	$Wallnut.set_shield_visible(false)


func _on_tier_2b_empower_body_entered(body: Node2D) -> void:
	print(body, " // ",body.get_groups())
	if body.is_in_group("plant"):
		var max_health = body.get_node("plant_health_management_behaviour")
		if max_health: 
			max_health.grow_armor_to(1)
			$plant_health_management_behaviour.gain_armor(1)
		else: 
			print("has no max_health node...")
