extends Powerup

var normal_mode_scene: PackedScene = preload("res://scenes/paddle_normal_mode.tscn")
var laser_mode_scene: PackedScene = preload("res://scenes/paddle_laser_mode.tscn")


func enable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var laser_mode = laser_mode_scene.instantiate() as LaserPaddleMode
		paddle.set_mode(laser_mode)


func disable_powerup() -> void:
	super()
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	if paddle:
		var normal_mode = normal_mode_scene.instantiate() as NormalPaddleMode
		paddle.set_mode(normal_mode)
