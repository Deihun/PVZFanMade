extends Node
@export var _amount_of_movement : float = 2.55
@export var _movement_repeatition : int = 20
@export var animation_node : Node2D
@export var final_render : Node2D
@export_enum("LEFT","RIGHT") var zombie_direction := "LEFT"
var __im_eating := false

var animation_player: AnimationPlayer
var active_cc := {
	"stun": [],
	"freeze": [],
	"slow": [],   # stores dictionaries {multiplier, timer}
	"chill": []   # only one allowed
}

var shader_mat: ShaderMaterial = null


func _ready() -> void:
	if animation_node:
		if animation_node.has_method("get_animation_player"):
			animation_player = animation_node.get_animation_player()

		if animation_node.material and animation_node.material is ShaderMaterial:
			shader_mat = animation_node.material.duplicate()
			animation_node.material = shader_mat




# --------------------
# MOVEMENT
# --------------------
func move() -> void:
	__im_eating = false
	var zombie:CharacterBody2D = get_parent()
	var movement = _amount_of_movement if zombie_direction == "RIGHT" else -_amount_of_movement

	for i in _movement_repeatition:
		if __im_eating: return
		if _is_disabled():
			_update_animation_state()
			await get_tree().create_timer(0.05).timeout
			continue

		var final_movement = movement * _get_slow_multiplier() * _get_chill_multiplier()
		zombie.position.x += final_movement
		_update_animation_state()
		await get_tree().create_timer(0.05).timeout


# --------------------
# CROWD CONTROL APPLY
# --------------------
func apply_stun(duration: float) -> void:
	_add_cc("stun", duration)

func apply_freeze(duration: float) -> void:
	_add_cc("freeze", duration)

func apply_slow(duration: float, multiplier: float) -> void:
	# keep only the strongest slow (lowest multiplier)
	for slow in active_cc["slow"]:
		if multiplier >= slow["multiplier"]:
			# weaker or equal → ignore
			return
	# clear weaker slows
	active_cc["slow"].clear()
	_add_cc("slow", duration, multiplier)

func apply_chill(duration: float, multiplier: float = 0.5) -> void:
	# If a chill is already active, just replace it with a new one
	if active_cc["chill"].size() > 0:
		active_cc["chill"].clear()

	# Add new chill entry
	_add_cc("chill", duration, multiplier)



# --------------------
# CC CORE
# --------------------
func _add_cc(type: String, duration: float, multiplier := 1.0) -> void:
	var timer := get_tree().create_timer(duration)

	if type == "slow" or type == "chill":
		var entry = { "multiplier": multiplier, "timer": timer }
		if type == "chill":
			active_cc["chill"] = [entry]  # force only one
		else:
			active_cc[type].append(entry)
	else:
		active_cc[type].append(timer)

	# When CC ends
	timer.timeout.connect(func():
		if type == "slow" or type == "chill":
			active_cc[type] = active_cc[type].filter(func(s): return s["timer"] != timer)
		else:
			active_cc[type].erase(timer)

		if type == "chill" and active_cc["chill"].is_empty():
			_set_chill_strength(0.0)

		_update_animation_state()
	)

	if type == "chill":
		_set_chill_strength(0.5)  # apply visual

	_update_animation_state()


# --------------------
# HELPERS
# --------------------
func _is_disabled() -> bool:
	return active_cc["stun"].size() > 0 or active_cc["freeze"].size() > 0

func _get_slow_multiplier() -> float:
	if active_cc["slow"].is_empty():
		return 1.0
	# return the strongest (lowest) slow multiplier
	var multipliers = active_cc["slow"].map(func(s): return s["multiplier"])
	return multipliers.min()

func _get_chill_multiplier() -> float:
	if active_cc["chill"].is_empty():
		return 1.0
	return active_cc["chill"][0]["multiplier"]

func _set_chill_strength(value: float) -> void:
	final_render.material.set("shader_parameter/darkblue_override", (value != 0.0))



# --------------------
# ANIMATION SYNC
# --------------------
func _update_animation_state() -> void:
	if animation_player == null:
		return

	if _is_disabled():
		animation_player.pause()
		animation_player.speed_scale = 0.0
	else:
		if !animation_player.is_playing():
			animation_player.play()
		animation_player.speed_scale = _get_slow_multiplier() * _get_chill_multiplier()
