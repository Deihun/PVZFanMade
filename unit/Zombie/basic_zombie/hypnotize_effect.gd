extends Node2D

func _ready() -> void:
	position.y -= 150
	z_index = 10
	var parent : CharacterBody2D = get_parent()
	var bite_detection := parent.get_node("Bite_Detection")
	var hitpoint := parent.get_node("HitPoint")
	
	parent.modulate = Color("#ffbbff")
	parent.enemy_group = "zombie"
	parent.remove_from_group("zombie")
	parent.add_to_group("plant")
	parent.scale.x = -1.0
	parent.speed*= -1
	parent.collision_layer = 0
	parent.collision_mask = 0
	parent.collision_layer = 1 << (1 - 1)  # or simply 1
	parent.collision_mask = (1 << (2 - 1)) | (1 << (4 - 1))
	
	bite_detection.collision_layer = 0
	bite_detection.collision_mask = 0
	bite_detection.collision_mask = (1 << (2 - 1)) | (1 << (4 - 1))
	
	hitpoint.collision_layer = 0
	hitpoint.collision_mask = 0
	hitpoint.collision_layer = 1 << (1 - 1)  # or simply 1
	hitpoint.collision_mask = (1 << (2 - 1)) | (1 << (4 - 1))
