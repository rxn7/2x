class_name Sound

var stream: AudioStream
var pitch: float

func _init(_stream: AudioStream, _pitch: float) -> void:
	stream = _stream
	pitch = _pitch