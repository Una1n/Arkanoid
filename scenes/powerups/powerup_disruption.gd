extends Powerup
class_name PowerupDisruption


func enable_powerup() -> void:
	super()
	var world = get_tree().get_first_node_in_group("World") as World
	var ball: Ball = world.ball_scene.instantiate()
	var ball2: Ball = world.ball_scene.instantiate()
	var current_ball = get_tree().get_first_node_in_group("Ball") as Ball
	if is_instance_valid(current_ball):
		ball.position = current_ball.position
		ball2.position = current_ball.position
	world.add_child(ball)
	world.add_child(ball2)
	ball.on_screen_exited.connect(world.on_ball_exited_screen)
	ball2.on_screen_exited.connect(world.on_ball_exited_screen)

	# Making sure the direction is never fully left/right
	ball.start_moving(Vector2(randf_range(-1.0, 1.0), get_random_direction_y()))
	ball2.start_moving(Vector2(randf_range(-1.0, 1.0), get_random_direction_y()))


func disable_powerup() -> void:
	super()


func get_random_direction_y() -> float:
	# Making sure the direction is never fully left/right
	var direction_y: float = 0.2
	if randi_range(1, 2) == 1:
		direction_y = randf_range(0.2, 1.0)
	else:
		direction_y = randf_range(-1.0, -0.2)

	return direction_y
