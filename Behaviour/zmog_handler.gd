extends Node

var amount_of_zmog_with_me: Array = []
var _previous_layers: int = 0

func _zmog_handlers() -> void:
	var parent := get_parent()
	if parent == null or not parent is CollisionObject2D:
		return
	if amount_of_zmog_with_me.size() > 0:
		if _previous_layers == 0:
			_previous_layers = parent.collision_layer
		parent.collision_layer = 1 << 5  
	else:
		if _previous_layers != 0:
			var restore_layers := _previous_layers & ~(1 << 5)
			parent.collision_layer = restore_layers
			_previous_layers = 0


func add_new_zmog(node : Node)-> void:
	amount_of_zmog_with_me.append(node)
	_zmog_handlers()

func remove_zmog(node : Node)-> void:
	amount_of_zmog_with_me.erase(node)
	_zmog_handlers()
