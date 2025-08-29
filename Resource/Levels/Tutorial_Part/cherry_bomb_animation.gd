extends Node2D
var method_upon_explode : Callable

func explode():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("explode")

func _explode():
	if method_upon_explode.is_valid():method_upon_explode.call()
