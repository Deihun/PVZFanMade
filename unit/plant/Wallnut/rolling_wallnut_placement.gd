extends Node2D
@export_enum("RollingWallnut","ExplodeONut") var _selected_wallnut := "RollingWallnut"

func _ready() -> void:
	$Wallnut._idle_explodenut()
