extends CharacterBody2D

@export var damage := 2000
@export var time_it_take_to_unarmed := 20
@onready var cfe := $check_for_explosion 


var current_time_it_takes_to_arm := 20

var can_reduce_arming_tier1b := false

func _ready() -> void:
	add_to_group("plant")
	$PotatoMine_animation.callable_explode = Callable(self,"explode")
	$EvolutionSenderSupportBehavior.tier1A_callable= Callable(self,"tier1a")
	$EvolutionSenderSupportBehavior.tier2A_callable= Callable(self,"tier2a")
	$EvolutionSenderSupportBehavior.tier3A_callable= Callable(self,"tier3a")
	$EvolutionSenderSupportBehavior.tier1B_callable= Callable(self,"tier1b")
	$EvolutionSenderSupportBehavior.tier2B_callable= Callable(self,"tier2b")
	$EvolutionSenderSupportBehavior.tier3B_callable= Callable(self,"tier3b")

func potato_arm():
	$EvolutionSenderSupportBehavior.increase_progress_evolution(1)
	$PotatoMine_animation.arming()
	$check_for_explosion/CollisionShape2D.disabled = false
	if $EvolutionSenderSupportBehavior._tier2b_obtain: $plant_health_management_behaviour.gain_shield(500)
	$arming_timer.stop()
	

func potato_unarmed():
	$PotatoMine_animation.play_idle_unarmed()
	current_time_it_takes_to_arm = time_it_take_to_unarmed
	$check_for_explosion/CollisionShape2D.disabled = true
	if $EvolutionSenderSupportBehavior._tier2b_obtain: $plant_health_management_behaviour.shield =0
	$arming_timer.stop()
	$arming_timer.start()

func _on_arming_timer_timeout() -> void:
	current_time_it_takes_to_arm = current_time_it_takes_to_arm - 1 if current_time_it_takes_to_arm > 0 else 0
	if current_time_it_takes_to_arm <= 0 and $check_for_explosion/CollisionShape2D.disabled: potato_arm()

func explode():
	var spuddow = load("res://unit/plant/Potatomine/spuddow_explosion.tscn").instantiate()
	spuddow.damage=damage
	get_tree().current_scene.add_child(spuddow)
	spuddow.global_position=self.global_position
	if $EvolutionSenderSupportBehavior._tier2a_obtain:
		var spuddow2 = spuddow.duplicate()
		spuddow2.delay = 25.0 if $EvolutionSenderSupportBehavior._tier3b_obtain else 15
		get_tree().current_scene.add_child(spuddow2)
	if $EvolutionSenderSupportBehavior._tier3a_obtain:
		var spuddow2 = spuddow.duplicate()
		var spuddow3 = spuddow.duplicate()
		spuddow2.global_position.x += 150
		spuddow3.global_position.x += 300
		spuddow2.delay = 0.5
		spuddow3.delay = 1
		get_tree().current_scene.add_child(spuddow2)
		get_tree().current_scene.add_child(spuddow3)
	if $EvolutionSenderSupportBehavior._tier3b_obtain: 
		potato_unarmed()
		damage+= 100
	else: queue_free()


func tier1a():
	potato_unarmed()
	damage += 500
func tier2a():
	potato_unarmed()
	$plant_health_management_behaviour.heal_maxhealth_percentage(100)
func tier3a():
	$PotatoMine_animation._tier3a()
	potato_unarmed()

func tier1b():
	potato_unarmed()
	can_reduce_arming_tier1b=true
	$zombie_sensor_tier1b/CollisionShape2D.disabled= false
func tier2b():
	potato_unarmed()

func tier3b():
	potato_unarmed()
	$PotatoMine_animation._tier3b()
	time_it_take_to_unarmed += 10


func _on_check_for_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and !body.is_in_group("testing"): 
		$PotatoMine_animation.explode()


func _on_zombie_sensor_tier_1b_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and can_reduce_arming_tier1b: 
		current_time_it_takes_to_arm -= 7 if $EvolutionSenderSupportBehavior._tier3b_obtain else 2
		can_reduce_arming_tier1b = false
		$tier1b_cooldown_reduction.start()

func _on_tier_1b_cooldown_reduction_timeout() -> void:
	can_reduce_arming_tier1b = true
