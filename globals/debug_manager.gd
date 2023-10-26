extends Node
class_name DebugManager

var current_world: World

func _init(world: World) -> void:
	current_world = world


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build(): return

	if event.is_action_pressed("debug_next_level"):
		SceneManager.go_to_next_level(current_world.scene_file_path)

	if event.is_action_pressed("debug_prev_level"):
		SceneManager.go_to_prev_level(current_world.scene_file_path)

	if event.is_action_pressed("debug_destroy_bricks"):
		current_world.on_level_cleared.emit()

	if event.is_action_pressed("debug_add_life"):
		LifeManager.add_life()

	if event.is_action_pressed("debug_remove_life"):
		LifeManager.remove_life()

	if event.is_action_pressed("debug_open_gate"):
		current_world.gate.open()

	if event.is_action_pressed("debug_drop_powerup"):
		current_world.powerup_manager.spawn_powerup(Vector2(500, 300))

	if event.is_action_pressed("debug_ball_right"):
		current_world.current_ball.velocity = Vector2(1, 0.05) * current_world.current_ball.__SPEED

	if event.is_action_pressed("debug_pause_ball"):
		if current_world.current_ball.velocity == Vector2.ZERO:
			current_world.current_ball.start_moving(Vector2(0.7, -1))
		else:
			current_world.current_ball.velocity = Vector2.ZERO

	if event.is_action_pressed("debug_screenshot"):
		Utils.take_screenshot(get_viewport())
