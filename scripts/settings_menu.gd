class_name SettingsMenu extends Control

@export var background: ColorRect

@export var master_volume_label: Label
@export var music_volume_label: Label
@export var sfx_volume_label: Label

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

var slider_granularity: int = 100

var popup: bool = false:
	set(value):
		popup = value
		if popup:
			background.modulate = Color(3, 7, 16, 1)
		else:
			background.modulate = Color(3, 7, 16, 0)


func _ready() -> void:
	%SaveButton.grab_focus()
	# TODO: Load settings from file
	master_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioManager.MASTER_BUS_ID)) * slider_granularity
	music_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioManager.MUSIC_BUS_ID)) * slider_granularity
	sfx_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioManager.SFX_BUS_ID)) * slider_granularity


func _on_master_slider_value_changed(value: float) -> void:
	# HACK to not make the slider expand when dropping below 100
	if value == 100:
		master_volume_label.text = "%s" % value
	else:
		master_volume_label.text = " %s" % value


func _on_music_slider_value_changed(value: float) -> void:
	music_volume_label.text = "%s" % value


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = "%s" % value


func _on_save_button_pressed() -> void:
	AudioManager.set_master_volume(master_slider.value / slider_granularity)
	AudioManager.set_music_volume(music_slider.value / slider_granularity)
	AudioManager.set_sfx_volume(sfx_slider.value / slider_granularity)

#	print("Master: %s" % AudioServer.get_bus_volume_db(AudioManager.MASTER_BUS_ID))
#	print("Music: %s" % AudioServer.get_bus_volume_db(AudioManager.MUSIC_BUS_ID))
#	print("SFX: %s" % AudioServer.get_bus_volume_db(AudioManager.SFX_BUS_ID))
	# TODO: Save Settings
	return_to_scene()


func _on_cancel_button_pressed() -> void:
	return_to_scene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		return_to_scene()


func return_to_scene() -> void:
	if popup:
		queue_free()
	else:
		SceneManager.go_to_previous_scene()
