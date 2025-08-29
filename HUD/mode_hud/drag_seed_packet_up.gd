extends Node2D

var detected:=0


func _process(delta: float) -> void:
	if detected<=0 : position.y -= 2.5
	


func _on_stopper_detector_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	detected+=1


func _on_stopper_detector_area_exited(area: Area2D) -> void:
	detected-=1


func _on_child_exiting_tree(node: Node) -> void:
	queue_free()
