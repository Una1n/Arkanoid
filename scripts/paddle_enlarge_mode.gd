extends PaddleMode
class_name EnlargePaddleMode


func enable() -> void:
	paddle.size = 96
	paddle.collision_node.shape.size = Vector2(96, 14)
	if paddle.position.x >= 175 - 17:
		paddle.position.x = 175 - 17
	if paddle.position.x <= -175 + 17:
		paddle.position.x = -175 + 17
