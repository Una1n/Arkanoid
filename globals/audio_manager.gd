extends Node

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

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


func get_linear_volume(bus_index: int) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func set_master_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(volume))
	AudioServer.set_bus_mute(MASTER_BUS_ID, volume < .05)


func set_music_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, volume < .05)


func set_sfx_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, volume < .05)
