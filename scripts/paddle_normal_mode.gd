extends PaddleMode
class_name NormalPaddleMode


func enable() -> void:
	paddle.size = 64
	paddle.collision_node.shape.size = Vector2(64, 14)
