extends Control

var level_instance: PackedScene = preload("res://scenes/levels/level1.tscn")


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(level_instance)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
