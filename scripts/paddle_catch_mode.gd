class_name CatchPaddleMode extends PaddleMode


var attached_ball: Ball = null


func on_ball_hit(ball: Ball) -> void:
	ball.velocity = Vector2.ZERO
	attach_ball(ball)


func attach_ball(ball: Ball) -> void:
	if is_instance_valid(attached_ball):
		release_ball()

	ball.reparent(paddle)
	attached_ball = ball


func release_ball() -> void:
	var world = get_tree().get_first_node_in_group("World") as World
	if is_instance_valid(world):
		attached_ball.start_moving(attached_ball.current_direction)
		attached_ball.reparent(world)

	attached_ball = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button") and is_instance_valid(attached_ball):
		release_ball()


func disable() -> void:
	if is_instance_valid(attached_ball):
		release_ball()
