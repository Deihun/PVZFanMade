extends CharacterBody2D

func _ready() -> void:
	$iceberg_as_group/AnimationPlayer.play("spawn")
	$iceberg_as_group.connect("ice_it",Callable(self,"freeze_the_zombie"))
	$iceberg_as_group.connect("destroy",Callable(self,"destroy_us"))

func _on_detection_area_enemy_detected() -> void:
	$iceberg_as_group._trigger_iceberg()


func freeze_the_zombie() -> void:
	if !$Detection_Area:  return
	if $Detection_Area.zombies_inside.size() <= 0:  return
	var target_zombie = $Detection_Area.zombies_inside.back()
	var movement =target_zombie.get_node("zombie_movement_management")
	if movement: movement.apply_freeze(15.0)

func destroy_us()->void:
	queue_free()
