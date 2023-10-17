extends Node

var channels: int = 8
var bus: String = "SFX"

var available: Array[AudioStreamPlayer] = []
var queue: Array[String] = []


func _ready():
	for i in channels:
		var audio_player := AudioStreamPlayer.new()
		add_child(audio_player)
		available.append(audio_player)
		audio_player.finished.connect(_on_stream_finished.bind(audio_player))
		audio_player.bus = bus


func _on_stream_finished(stream: AudioStreamPlayer):
	available.append(stream)


func play(sound_path: String):
	queue.append(sound_path)


func _process(_delta: float):
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].pitch_scale = randf_range(0.75, 1.25)
		available[0].play()
		available.pop_front()
