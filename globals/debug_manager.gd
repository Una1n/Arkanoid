extends Node
class_name DebugManager

var current_world: World

func _init(world: World) -> void:
	current_world = world


func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("debug_next_level"):
		SceneManager.go_to_next_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_prev_level"):
		SceneManager.go_to_prev_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_destroy_bricks"):
		current_world.on_level_cleared.emit()

	if OS.is_debug_build() and event.is_action_pressed("debug_add_life"):
		LifeManager.add_life()

	if OS.is_debug_build() and event.is_action_pressed("debug_remove_life"):
		LifeManager.remove_life()

	if OS.is_debug_build() and event.is_action_pressed("debug_open_gate"):
		current_world.gate.open()

	if OS.is_debug_build() and event.is_action_pressed("debug_drop_powerup"):
		current_world.powerup_manager.spawn_powerup(Vector2(670, 300))

	if OS.is_debug_build() and event.is_action_pressed("debug_ball_right"):
		current_world.current_ball.velocity = Vector2(1, 0.05) * current_world.current_ball.__SPEED

	if OS.is_debug_build() and event.is_action_pressed("debug_pause_ball"):
		current_world.current_ball.velocity = Vector2(0, 0)
