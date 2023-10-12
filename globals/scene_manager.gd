extends CanvasLayer

var current_level_nr: int = 1
var in_transition: bool = false

signal on_load_first_level

func go_to_first_level() -> void:
	current_level_nr = 1
	if ResourceLoader.exists("res://scenes/levels/level%s.tscn" % current_level_nr):
		_transition_level("res://scenes/levels/level%s.tscn" % current_level_nr)
		on_load_first_level.emit()
	else:
		printerr("Level %s not found!" % current_level_nr)


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
	_disable_world_process()
	%RoundLabel.text = "Round %s" % current_level_nr
	$AnimationPlayer.play("fadein_round")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(level)
	_end_transition()


func go_to_main_menu() -> void:
	in_transition = true
	_disable_world_process()
	$AnimationPlayer.play("fadein")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
	_end_transition()


func go_to_game_over() -> void:
	in_transition = true
	_disable_world_process()
	$AnimationPlayer.play("fadein")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	_end_transition()


func _end_transition() -> void:
	%DissolveRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$AnimationPlayer.play("fadeout")
	await $AnimationPlayer.animation_finished
	in_transition = false


func _disable_world_process() -> void:
	%DissolveRect.mouse_filter = Control.MOUSE_FILTER_STOP
	var world := get_tree().get_first_node_in_group("World") as World
	if is_instance_valid(world):
		world.process_mode = Node.PROCESS_MODE_DISABLED
