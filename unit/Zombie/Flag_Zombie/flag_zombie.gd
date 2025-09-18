extends Node2D

var detected_plant
var damage := 10
var speed = 2.5
var enemy_group = "plant"


@onready var collision_shape = $CollisionShape2D
func _ready() -> void:
	add_to_group("zombie")
	$zombie_hp_management.head_attachment_for_holding_armor = $SubViewport/animation_node._armor
	$zombie_hp_management._add_health_threshold_condition(func(): lose_its_arms(),50, 5, true)
	var play_death_callable : Callable = Callable(self,"death")
	$zombie_hp_management.zombie_death_callable.append(play_death_callable)
	$SubViewport/animation_node.walk_callable = Callable($zombie_movement_management,"move")
	$SubViewport/animation_node.eat_callable = Callable(self,"eat_plant")
	$SubViewport/animation_node.disappear_callable = Callable(self,"disappear")
	$SubViewport/animation_node.set_flag_zombie()
	$SubViewport/animation_node.walk()

func _move_forward():
	for i in 20:
		position.x -= speed
		await get_tree().create_timer(0.05).timeout

func eat_plant():
	if !detected_plant:
		detected_plant = null
		$SubViewport/animation_node.walk()
		return
	var plant_health_management = detected_plant.get_node("plant_health_management_behaviour")
	if plant_health_management: plant_health_management.perform_damage(damage)
	else: 
		plant_health_management = detected_plant.get_node("zombie_hp_management")
		if plant_health_management: plant_health_management.take_damage(damage)
		else: 
			print("UNABLE TO DETECT TARGET")

func lose_its_arms():
	$SubViewport/animation_node.base_zombie_is_half()


func death():
	if$CollisionShape2D :$CollisionShape2D.queue_free()
	if$HitPoint : $HitPoint.queue_free()
	if $Bite_Detection: $Bite_Detection.queue_free()
	$SubViewport/animation_node.dead()
	detected_plant = null
	if collision_shape: collision_shape.queue_free()

func disappear():
	queue_free()

func _on_bite_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group(enemy_group) and !body.is_in_group("untargettable") and !body.is_in_group("testing"):
		detected_plant = body
		$SubViewport/animation_node.eat()




func _on_bite_detection_body_exited(body: Node2D) -> void:
	if body == detected_plant and detected_plant: detected_plant =null
