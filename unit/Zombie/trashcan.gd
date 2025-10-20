extends Area2D

@export var hp :int= 750
var current_hp: int
func _ready() -> void:
	current_hp =hp


func take_damage(value:float)->void:
	current_hp-= value
	if current_hp > (hp*0.4) and (hp*0.7) >current_hp:
		$TrashcanHpFull.texture =preload("res://unit/Zombie/shields/trashcan_hp_damage.png")
	if current_hp < (hp*0.4):
		$TrashcanHpFull.texture =preload("res://unit/Zombie/shields/trashcan_hp_lethal.png")
		if current_hp <= 0:
			queue_free()
