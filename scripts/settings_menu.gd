extends Control

@export var master_volume_label: Label
@export var music_volume_label: Label
@export var sfx_volume_label: Label


func _ready() -> void:
	%SaveButton.grab_focus()


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
