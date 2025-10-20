extends Node2D

func _ready() -> void:
	for i in [$Projectile, $Projectile2, $Projectile3, $Projectile4, $Projectile5, $Projectile6, $Projectile7, $Projectile8]:
		i.damage = 50


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
