@tool
extends Node

func _ready() -> void:
	var path = get_parent().image_path
	if !path: return
	var image_texture = load(path)
	if !image_texture: return
	$"../SeedPacket".texture = image_texture
