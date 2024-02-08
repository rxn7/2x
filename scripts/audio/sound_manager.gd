extends Node

const INIT_POOL_SIZE = 6

var available_players: Array = []
var pool_size: int = 0
var playing_count: int = 0

func _ready() -> void:
	for _i in INIT_POOL_SIZE:
		available_players.push_back(create_new_player())

## If pool is empty, creates a new player
func play(sound: Sound) -> void:
	var player: AudioStreamPlayer
	if !available_players.is_empty():
		player = available_players.pop_back()
	else:
		player = create_new_player()

	_play(player, sound)

func _play(player: AudioStreamPlayer, sound: Sound) -> void:
	playing_count += 1
	player.stream = sound.stream
	player.pitch_scale = sound.pitch
	player.play()

func play_spawn_sound() -> void:
	play(Sound.new(SoundLibrary.SPAWN_SOUNDS.pick_random(), randf_range(0.7, 1.3)))

func play_merge_sound() -> void:
	play(Sound.new(SoundLibrary.MERGE_SOUND, randf_range(0.7, 1.3)))

func create_new_player() -> AudioStreamPlayer:
	pool_size += 1

	var p: AudioStreamPlayer = AudioStreamPlayer.new()
	p.finished.connect(func(): on_player_finished(p))

	add_child(p)
	return p

func on_player_finished(player: AudioStreamPlayer) -> void:
	playing_count -= 1
	available_players.push_back(player)
