extends Node

var current_level_nr: int = 1
var current_level: PackedScene

func go_to_next_level() -> void:
	current_level_nr += 1
	current_level = load("res://scenes/levels/level%s.tscn" % current_level_nr)
	if current_level:
		get_tree().change_scene_to_packed(current_level)
	else:
		printerr("No level found for level nr: %s!" % current_level_nr)

func go_to_prev_level() -> void:
	if current_level_nr == 1:
		printerr("No level before level 1!")
		return

	current_level_nr -= 1
	current_level = load("res://scenes/levels/level%s.tscn" % current_level_nr)
	get_tree().change_scene_to_packed(current_level)
