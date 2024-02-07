extends Node

const POOL_SIZE = 12

var available: Array = []
var queue: Array = []

func _ready() -> void:
	for _i in range(POOL_SIZE):
		var p: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(p)
		available.push_back(p)
		p.connect("finished", func(): on_player_finished(p))

func on_player_finished(player: AudioStreamPlayer) -> void:
	available.push_back(player)

func play(sound: Sound) -> void:
	while(queue.size() > POOL_SIZE):
		queue.pop_back()

	queue.append(sound)

func _process(_delta: float) -> void:
	if not queue.is_empty() and not available.is_empty():
		var p: AudioStreamPlayer = available.pop_front()
		var s: Sound = queue.pop_front()
		p.stream = s.stream
		p.pitch_scale = s.pitch
		p.play()
