extends Area2D

@export_enum("plant", "zombie") var assign_owner : String = "plant"
var number_detected : int = 0
var detect_group: String = ""

signal enemy_detected
signal no_more_enemies

var on_enemy_entered_callable: Callable = Callable()
var on_no_more_enemies_callable: Callable = Callable()

func _ready() -> void:
	pass
	if assign_owner == "plant":
		detect_group = "zombie"
	else:
		detect_group = "plant"
#WHAT DOES THIS CODE EXACTLY DO? CAUSE I REMOVE THIS AND IT WORKS. Plant is 1, Zombie is 2 for layer and mask but this code messes up everything.

func _on_body_entered(body: Node2D) -> void:
	if detect_group not in body.get_groups() or body.is_in_group("spawn_protection"): return
	number_detected += 1
	emit_signal("enemy_detected")
	if on_enemy_entered_callable.is_valid():
		on_enemy_entered_callable.call()

func _on_body_exited(body: Node2D) -> void:
	if detect_group not in body.get_groups(): return
	number_detected -= 1 if number_detected > 0 else 0
	if number_detected == 0:
		emit_signal("no_more_enemies")
		if on_no_more_enemies_callable.is_valid():
			on_no_more_enemies_callable.call()
