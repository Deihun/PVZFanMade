extends Node2D
var click_callbacks: Array[Callable] = []
var _when_I_expire_call_functions : Array[Callable] = []
var master

@export var sunbank_package : PackedScene 
@export_category("Sun Property")
@export var sun_value : int = 25
@export_enum("down","right","none") var sun_movement : String = "none"
@export var does_sun_expire : bool = true
@export var sun_expiration_value : int = 10


func _add_callable_on_sun(method : Callable):
	$sun_animation.click_callbacks.append(method)


func _when_click_to_collect():
	QuickDataManagement.add_sun(sun_value)
	if QuickDataManagement.mode_normal_selection: QuickDataManagement.mode_normal_selection.update_all_hud()
	var a = randf_range(0.5,0.8)
	var tween = create_tween()
	tween.tween_property(self, "global_position", QuickDataManagement._sun_bank_position, a).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(a).timeout
	self.queue_free()


func _ready() -> void:
	var collect_sun_callable : Callable = Callable(self,"_when_click_to_collect")
	$sun_animation.click_callbacks.append(collect_sun_callable)
	if does_sun_expire:
		$expiration.wait_time = sun_expiration_value
		$expiration.start()


func _on_expiration_timeout() -> void:
	if master: master.sun_last_position=global_position
	for methods in _when_I_expire_call_functions:
		if methods.is_valid(): methods.call()
	
	self.queue_free()
