extends CanvasLayer

var current_level_nr: int = 1
var in_transition: bool = false

func go_to_next_level() -> void:
	current_level_nr += 1
	if ResourceLoader.exists("res://scenes/levels/level%s.tscn" % current_level_nr):
		_transition_level("res://scenes/levels/level%s.tscn" % current_level_nr)
	else:
		printerr("Level %s not found!" % current_level_nr)


func go_to_prev_level() -> void:
	if current_level_nr == 1:
		printerr("No level before level 1!")
		return

	current_level_nr -= 1
	_transition_level("res://scenes/levels/level%s.tscn" % current_level_nr)


func _transition_level(level: String) -> void:
	in_transition = true
	var world = get_tree().get_first_node_in_group("World") as World
	world.process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.play("fadein_round")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(level)
	$AnimationPlayer.play("fadeout")
	await $AnimationPlayer.animation_finished
	in_transition = false
