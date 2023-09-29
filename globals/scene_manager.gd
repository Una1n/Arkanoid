extends Node

var current_level_nr: int = 1
var current_level: PackedScene

func go_to_next_level() -> void:
	current_level_nr += 1
	current_level = load("res://scenes/levels/level%s.tscn" % current_level_nr)
	get_tree().change_scene_to_packed(current_level)
