extends Node2D

@export var speed : float = 450.0
@export var pierce : int = 1
var master
var damage : int
var ignore_armor : bool = false

func _ready():
	add_to_group("ally_projectile")

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT * speed * delta

func reduce_pierce(value : int = 1):
	pierce -= value
	if pierce <= 0: queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	return
	if body.get_groups().has("zombie"):
		await get_tree().create_timer(0.01)
