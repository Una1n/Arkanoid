extends Node

const MASTER_BUS: String = "Master"
const SFX_BUS: String = "SFX"
const MUSIC_BUS: String = "Music"

@onready var MASTER_BUS_ID = AudioServer.get_bus_index(MASTER_BUS)
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index(MUSIC_BUS)
@onready var SFX_BUS_ID = AudioServer.get_bus_index(SFX_BUS)

var sfx_channels: int = 8
var music_player: AudioStreamPlayer

var available: Array[AudioStreamPlayer] = []
var queue: Array[String] = []


func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = MUSIC_BUS

	for i in sfx_channels:
		var audio_player := AudioStreamPlayer.new()
		add_child(audio_player)
		available.append(audio_player)
		audio_player.finished.connect(_on_stream_finished.bind(audio_player))
		audio_player.bus = SFX_BUS


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
