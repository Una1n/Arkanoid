extends Powerup


func enable_powerup() -> void:
	super()
	var ball = get_tree().get_first_node_in_group("Ball") as Ball
	if ball:
		ball.slow_speed()


func disable_powerup() -> void:
	super()
	var ball = get_tree().get_first_node_in_group("Ball") as Ball
	if ball:
		ball.normal_speed()
