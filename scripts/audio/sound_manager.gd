extends Node

const INIT_POOL_SIZE = 12

var available_players: Array[AudioStreamPlayer] = []
var pool_size: int = 0
var playing_count: int = 0

func _ready() -> void:
	for _i in INIT_POOL_SIZE:
		available_players.push_back(_create_new_player())

## If pool is empty, creates a new player
func play(stream: AudioStream, pitch: float = 1) -> void:
	var player: AudioStreamPlayer
	if !available_players.is_empty():
		player = available_players.pop_back()
	else:
		player = _create_new_player()

	playing_count += 1
	player.stream = stream
	player.pitch_scale = pitch
	player.play()

func _create_new_player() -> AudioStreamPlayer:
	pool_size += 1

	var p: AudioStreamPlayer = AudioStreamPlayer.new()
	p.finished.connect(func(): _on_player_finished(p))

	add_child(p)
	return p

func _on_player_finished(player: AudioStreamPlayer) -> void:
	playing_count -= 1
	available_players.push_back(player)

func play_spawn_sound() -> void:
	play(SoundLibrary.SPAWN_SOUNDS.pick_random(), randf_range(0.7, 1.3))

func play_merge_sound() -> void:
	play(SoundLibrary.MERGE_SOUND, randf_range(0.5, 1.5))