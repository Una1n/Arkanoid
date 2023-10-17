class_name CatchPaddleMode extends PaddleMode


var attached_ball: Ball = null
@onready var release_timer: Timer = $ReleaseTimer

func on_ball_hit(ball: Ball) -> void:
	ball.velocity = Vector2.ZERO
	attach_ball(ball)
	AudioManager.play("res://assets/audio/sfx/paddle_ball_catch.wav")


func attach_ball(ball: Ball) -> void:
	if is_instance_valid(attached_ball):
		release_ball()

	ball.reparent(paddle)
	attached_ball = ball
	release_timer.start()
	if not release_timer.timeout.is_connected(release_ball):
		release_timer.timeout.connect(release_ball)


func release_ball() -> void:
	var world = get_tree().get_first_node_in_group("World") as World
	if is_instance_valid(world):
		attached_ball.start_moving(attached_ball.current_direction)
		attached_ball.reparent(world)

	attached_ball = null
	release_timer.stop()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button") and is_instance_valid(attached_ball):
		release_ball()


func disable() -> void:
	if is_instance_valid(attached_ball):
		release_ball()
