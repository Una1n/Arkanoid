extends Powerup


func enable_powerup(world: World) -> void:
	super(world)
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		paddle.enlarge()


func disable_powerup(world: World) -> void:
	super(world)
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		paddle.normal_size()
