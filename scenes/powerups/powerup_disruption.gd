extends Powerup
class_name PowerupDisruption


func enable_powerup(world: World) -> void:
	super(world)
	var ball: Ball = world.ball_scene.instantiate()
	var ball2: Ball = world.ball_scene.instantiate()
	# TODO: error on current_ball with multiple balls around
	ball.position = world.current_ball.position
	ball2.position = world.current_ball.position
	world.add_child(ball)
	world.add_child(ball2)
	ball.on_screen_exited.connect(world.on_ball_exited_screen)
	ball2.on_screen_exited.connect(world.on_ball_exited_screen)
	ball.start_moving(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)))
	ball2.start_moving(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)))


func disable_powerup(world: World) -> void:
	super(world)
