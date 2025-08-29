extends Node

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	var node = get_parent().get_node("zombie_hp_management")
	if node: node.zombie_death_callable.append(Callable(self,"_exit_tree"))

func _process(delta: float) -> void:
	get_parent().modulate = self.modulate
	

func _exit_tree() -> void:
	var evolve_boost = load("res://HUD/EvolutionUI/EvolutionPowerBoost.tscn").instantiate()
	var spawn_drop = load("res://Behaviour/power_boost_drop.tscn").instantiate()
	get_tree().current_scene.add_child(evolve_boost)
	evolve_boost.global_position = get_parent().global_position
	evolve_boost.add_child(spawn_drop)
