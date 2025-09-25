extends Node2D

func unclaimed():
	$Gem.hide()
	$GemOutline.show()
	$Crack.hide()

func claimed():
	$Gem.show()
	$GemOutline.show()
	$Crack.hide()
	$AnimationPlayer.play("new_animation")

func ignore():
	$Gem.hide()
	$GemOutline.hide()
	$Crack.show()
