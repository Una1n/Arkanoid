extends Powerup


func enable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		paddle.enable_laser_mode()


func disable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		paddle.disable_laser_mode()
