extends CharacterBody2D

func _ready() -> void:
	$CherryBomb_animation.method_upon_explode=Callable(self,"explode")
	$CherryBomb_animation.explode()

func explode()->void:
	var explosion_area = load("res://unit/plant/CherryBomb/cherry_bomb_explosion_animation.tscn").instantiate()
	explosion_area.master =self
	explosion_area.visible=true
	explosion_area.position = Vector2.ZERO
	get_tree().current_scene.add_child(explosion_area)
	#explosion_area.global_position = self.global_position
	explosion_area.position = position
	explosion_area.explode()
	queue_free()
