extends Powerup


var paddle_scene: PackedScene = preload("res://scenes/paddle.tscn")
var laser_paddle_scene: PackedScene = preload("res://scenes/paddle_laser_mode.tscn")

var laser_paddle: PaddleLaser

func enable_powerup() -> void:
	super()
	var world = get_tree().get_first_node_in_group("World") as World
	var paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
	var old_position = paddle.position
	paddle.queue_free()
	laser_paddle = laser_paddle_scene.instantiate() as PaddleLaser
	world.paddle_position.call_deferred("add_child", laser_paddle)
	laser_paddle.position = old_position


func disable_powerup() -> void:
	super()
	var old_position = laser_paddle.position
	laser_paddle.disable()
	laser_paddle.queue_free()
	var world = get_tree().get_first_node_in_group("World") as World
	var paddle = paddle_scene.instantiate() as Paddle
	world.paddle_position.call_deferred("add_child", paddle)
	paddle.position = old_position
