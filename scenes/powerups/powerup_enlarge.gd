extends Powerup

@export var normal_mode_scene: PackedScene
@export var enlarge_mode_scene: PackedScene

func enable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var enlarge_mode = enlarge_mode_scene.instantiate() as EnlargePaddleMode
		paddle.set_mode(enlarge_mode)


func disable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var normal_mode = normal_mode_scene.instantiate() as NormalPaddleMode
		paddle.set_mode(normal_mode)
