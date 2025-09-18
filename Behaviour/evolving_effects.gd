extends Node2D

func play_for_tier1_Effect():
	_play_impact()

func play_for_tier2_Effect():
	play_for_tier1_Effect()
	_set_random_clutter()
	$Node2D/clutter_effect.play("play")

func _set_random_clutter():
	match randi_range(1,3):
		1:
			$"Node2D/1".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_1/1.png")
			$"Node2D/2".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_1/2.png")
			$"Node2D/3".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_1/3.png")
		2:
			$"Node2D/1".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_2/1.png")
			$"Node2D/2".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_2/2.png")
			$"Node2D/3".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_2/3.png")
		3:
			$"Node2D/1".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_3/1.png")
			$"Node2D/2".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_3/2.png")
			$"Node2D/3".texture=load("res://HUD/EvolutionUI/evolving_effects/evolve_clutter effects/variety_3/3.png")

func _play_impact():
	var texture_array : Array[Texture] = [
		load("res://HUD/EvolutionUI/evolving_effects/shiny_effects/1.png"),
		load("res://HUD/EvolutionUI/evolving_effects/shiny_effects/2.png"),
		load("res://HUD/EvolutionUI/evolving_effects/shiny_effects/3.png"),
		load("res://HUD/EvolutionUI/evolving_effects/shiny_effects/1.png")
	]
	for child in [$shiny_1,$shiny_2,$shiny_3,$shiny_4]:
		child.texture = texture_array.pick_random()
		child.scale = Vector2(randf_range(0.7,1.0),randf_range(0.7,1.0))
	self.show()
	$AnimationPlayer.play("trigger")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
