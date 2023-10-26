class_name EnlargePaddleMode extends PaddleMode


func on_ball_hit(_ball: Ball) -> void:
	paddle.play_hit_sfx()


func enable() -> void:
	paddle.size = 96
	paddle.collision_node.shape.size = Vector2(96, 14)
	if paddle.position.x >= 175 - 17:
		paddle.position.x = 175 - 17
	if paddle.position.x <= -175 + 17:
		paddle.position.x = -175 + 17
