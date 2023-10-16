extends Node2D
class_name PaddleMode

var paddle: Paddle = null


func _ready() -> void:
	paddle = get_parent() as Paddle


func enable() -> void: pass
func disable() -> void: pass
func on_ball_hit(_ball: Ball) -> void: pass
