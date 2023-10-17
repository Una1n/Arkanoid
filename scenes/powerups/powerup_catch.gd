extends Powerup

@export var normal_mode_scene: PackedScene
@export var catch_mode_scene: PackedScene


func enable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var catch_mode = catch_mode_scene.instantiate() as CatchPaddleMode
		paddle.set_mode(catch_mode)


func disable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var normal_mode = normal_mode_scene.instantiate() as NormalPaddleMode
		paddle.set_mode(normal_mode)
