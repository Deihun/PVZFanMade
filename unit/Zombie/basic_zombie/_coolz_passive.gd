extends Node
@export var time_interval_trigger := 15.0

func _ready() -> void:
	$indication.wait_time = time_interval_trigger
	$indication.start()



func _on_indication_timeout() -> void:
	var main_camera = get_tree().current_scene.get_node("main_camera")
	if !main_camera:return
	if main_camera.has_node("CoolzIndication"):return
	var coolz_effect_trigger := preload("res://unit/Zombie/Coolz_Zombie/Coolz_Indication.tscn").instantiate()
	main_camera.add_child(coolz_effect_trigger)
	coolz_effect_trigger.name="CoolzIndication"
