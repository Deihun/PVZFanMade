extends Node

@onready var audio1: AudioStreamPlayer = $music_player_1
@onready var audio2: AudioStreamPlayer = $music_player_2

var fade_time: float = 2.0
var current_player: AudioStreamPlayer = null
var next_player: AudioStreamPlayer = null

var start_up_wave: AudioStream
var mid_wave: AudioStream
var last_wave: AudioStream


func _ready() -> void:
	for a in 5:
		var audio:= AudioStreamPlayer.new()
		audio.bus = "SFX"
		$highest_priority_sfx_1.add_child(audio)
		a+=1
	for a in 10:
		var audio:= AudioStreamPlayer.new()
		audio.bus = "SFX"
		$play_sound_sfx_1.add_child(audio)
		a+=1
	for a in 5:
		var audio:= AudioStreamPlayer.new()
		audio.bus = "SFX"
		$play_explosion_sfx_1.add_child(audio)
		a+=1


func play_music(music : AudioStream = start_up_wave, loop := true) -> void:
	audio1.stop()
	audio2.stop()
	_set_loop(music, loop)
	audio1.stream = music
	audio1.play()
	audio1.volume_db = 0


func play_mid_wave() -> void:
	if !mid_wave: return
	_set_loop(mid_wave, false)
	_switch_music(mid_wave, false, Callable(self, "_resume_startup_music"))


func play_last_wave() -> void:
	if !last_wave:return
	_set_loop(last_wave, true)
	_switch_music(last_wave, true)


func _resume_startup_music() -> void:
	play_music()


func _switch_music(stream: AudioStream, loop: bool, after_finish: Callable = Callable()) -> void:
	if current_player == null or !current_player.playing:
		current_player = audio1
		next_player = audio2
	else:
		next_player = audio2  if(current_player == audio1)  else audio1

	# Setup next player
	next_player.stream = stream
	next_player.volume_db = -80
	next_player.play()

	# Fade between players
	_fade_between(current_player, next_player)


	if not loop and not next_player.finished.is_connected(_on_music_finished):
		next_player.finished.connect(_on_music_finished.bind(after_finish))


func _fade_between(old_player: AudioStreamPlayer, new_player: AudioStreamPlayer) -> void:
	if old_player != null and old_player.playing:
		var tween := create_tween()
		tween.parallel().tween_property(old_player, "volume_db", -80, fade_time)
		tween.parallel().tween_property(new_player, "volume_db", 0, fade_time)
		tween.tween_callback(Callable(self, "_on_fade_done").bind(old_player, new_player))
	else:
		var tween := create_tween()
		tween.tween_property(new_player, "volume_db", 0, fade_time)
		current_player = new_player
	await get_tree().create_timer(0.3).timeout
	new_player.stop()
	new_player.play()


func _on_fade_done(old_player: AudioStreamPlayer, new_player: AudioStreamPlayer) -> void:
	if old_player != null:
		old_player.stop()
	current_player = new_player


func _on_music_finished(after_finish: Callable) -> void:
	if after_finish.is_valid():
		after_finish.call()


func _set_loop(stream: AudioStream, loop: bool) -> void:
	if stream is AudioStreamOggVorbis:
		stream.loop = loop
	elif stream is AudioStreamMP3:
		stream.loop = loop
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if loop  else AudioStreamWAV.LOOP_DISABLED




var _can_play_zombie_groan:=true
func play_zombie_groan(_audio:AudioStream)->void:
	if !_can_play_zombie_groan:return
	_can_play_zombie_groan=false
	$zombie_groan/zombie_groan_cooldown.start()
	$zombie_groan.stream = _audio
	$zombie_groan.play()
func _on_zombie_groan_cooldown_timeout() -> void:
	_can_play_zombie_groan=true




func play_high_priority_audio(_audio : AudioStream):
	for child in $highest_priority_sfx_1.get_children():
		if child is AudioStreamPlayer:
			if child == null or child.playing: continue
			else:
				child.stream=_audio
				child.play()
				break
func play_sound_SFX(_audio : AudioStream):
	for child in $play_sound_sfx_1.get_children():
		if child is AudioStreamPlayer:
			if child == null or child.playing: continue
			else:
				child.stream=_audio
				child.play()
				break
func play_explosion_sound_SFX(_audio : AudioStream):
	for child in $play_explosion_sfx_1.get_children():
		if child is AudioStreamPlayer:
			if child == null or child.playing: continue
			else:
				child.stream=_audio
				child.play()
				break
