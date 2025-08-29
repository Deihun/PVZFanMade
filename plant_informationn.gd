extends Node

func _get_plant_as_animation(plant_name: String) -> Node2D:
	var plant_on_animation : Node2D
	match plant_name:
		"peashooter":
			plant_on_animation = load("res://unit/plant/peashooter/peashooter_animationn.tscn").instantiate()
		"sunflower":
			plant_on_animation = load("res://unit/plant/Sunflower/sunflower_animation.tscn").instantiate()
		"wallnut":
			plant_on_animation = load("res://unit/plant/Wallnut/Wallnut_animation.tscn").instantiate()
		"potatomine":
			plant_on_animation = load("res://unit/plant/Potatomine/potato_mine_animation.tscn").instantiate()
		"cherrybomb":
			plant_on_animation = load("res://unit/plant/CherryBomb/cherry_bomb_animation.tscn").instantiate()
	return plant_on_animation

func get_plant_seed_packet_image(plant_name: String) -> Texture:
	var plant_on_animation : Texture
	match plant_name:
		"peashooter":
			plant_on_animation = load("res://unit/plant/peashooter/peashooter_seedpacket.png")
		"sunflower":
			plant_on_animation = load("res://unit/plant/Sunflower/sunflower_seed_packet.png")
		"wallnut":
			plant_on_animation = load("res://unit/plant/Wallnut/wallnut_seed_packet.png")
		"potatomine":
			plant_on_animation = load("res://unit/plant/Potatomine/potatomine_seed_packet.png")
		_:
			plant_on_animation = load("res://unit/plant/peashooter/peashooter_seedpacket.png")
	return plant_on_animation

func _get_plant_(plant_name: String) -> Node2D:
	var plant_on_animation : Node2D
	match plant_name:
		"peashooter":
			plant_on_animation = load("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate()
		"sunflower":
			plant_on_animation = load("res://unit/plant/Sunflower/sunflower.tscn").instantiate()
		"wallnut":
			plant_on_animation = load("res://unit/plant/Wallnut/wallnut.tscn").instantiate()
		"potatomine":
			plant_on_animation = load("res://unit/plant/Potatomine/potatomine_script.tscn").instantiate()
		"cherrybomb":
			plant_on_animation = load("res://unit/plant/CherryBomb/CherryBomb.tscn").instantiate()
	return plant_on_animation


func get_plant_seed_packet(plant_name: String) -> PackedScene:
	var seed_packet_plant = load("res://HUD/borders/seed_packet.tscn").instantiate()
	match plant_name:
		"peashooter":
			seed_packet_plant.plant_name = "peashooter"
			
			seed_packet_plant.cooldown = 10
			seed_packet_plant.suncost = 100
		"sunflower":
			seed_packet_plant.plant_name = "sunflower"
			seed_packet_plant.cooldown = 10
			seed_packet_plant.suncost = 50
		"wallnut":
			seed_packet_plant.plant_name = "wallnut"
			seed_packet_plant.cooldown = 30
			seed_packet_plant.suncost = 50
		"potatomine":
			seed_packet_plant.plant_name = "potatomine"
			seed_packet_plant.cooldown = 30
			seed_packet_plant.suncost = 25
		"cherrybomb":
			seed_packet_plant.plant_name = "cherrybomb"
			seed_packet_plant.cooldown = 15
			seed_packet_plant.suncost = 150
	return seed_packet_plant
