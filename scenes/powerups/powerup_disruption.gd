extends Powerup


func enable_powerup() -> void:
	super()
	var world = get_tree().get_first_node_in_group("World") as World
	_create_ball(world)
	_create_ball(world)


func disable_powerup() -> void:
	super()


func is_allowed_to_spawn_powerups_while_active() -> bool:
	return get_tree().get_nodes_in_group("Ball").size() == 1


func _create_ball(world: World) -> void:
	var ball: Ball = world.ball_scene.instantiate()
	var current_ball = get_tree().get_first_node_in_group("Ball") as Ball
	if is_instance_valid(current_ball):
		ball.position = current_ball.position

	ball.on_screen_exited.connect(world.on_ball_exited_screen)
	world.add_child(ball)
	ball.start_moving(Vector2(randf_range(-1.0, 1.0), get_random_direction_y()))


func get_random_direction_y() -> float:
	# Making sure the direction is never fully left/right
	# And only make the direction go up so the player is not surprised
	return randf_range(-0.2, -1.0)
