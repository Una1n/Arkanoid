extends PaddleMode
class_name NormalPaddleMode


func on_ball_hit(_ball: Ball) -> void:
	paddle.play_hit_sfx()


func enable() -> void:
	paddle.size = 64
	paddle.collision_node.shape.size = Vector2(64, 14)
