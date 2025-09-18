extends SubViewport

@export var _animation_node : Node2D
@export var _sprite_rendering : Sprite2D

func _ready() -> void:
	_sprite_rendering.texture = get_texture()
	_sprite_rendering.material = _sprite_rendering.material.duplicate()
	
	var old_offset := _sprite_rendering.offset
	_sprite_rendering.offset = Vector2(0, (_sprite_rendering.texture.get_height() / 2) + 20)
	var offset_diff := _sprite_rendering.offset - old_offset
	_sprite_rendering.position -= offset_diff
	
func _process(delta: float) -> void:
	_sprite_rendering.material.set("shader_parameter/time",_sprite_rendering.material.get("shader_parameter/time")+0.01)
