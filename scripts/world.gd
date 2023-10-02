extends Node2D

@onready var started_game: bool = false

var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

var current_ball: Ball = null
var bricks_available: int = 100

signal on_level_cleared


func _ready() -> void:
	respawn_ball()
	on_level_cleared.connect(SceneManager.go_to_next_level)
	bricks_available = get_tree().get_nodes_in_group("Bricks").size()
	for node in get_tree().get_nodes_in_group("Bricks"):
		var brick = node as Brick
		brick.on_destroyed.connect(on_destroy_brick)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button"):
		if not started_game:
			current_ball.start_moving()
			current_ball.reparent(self)
			started_game = true

	if OS.is_debug_build() and event.is_action_pressed("debug_next_level"):
		SceneManager.go_to_next_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_prev_level"):
		SceneManager.go_to_prev_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_destroy_bricks"):
		on_level_cleared.emit()


func on_ball_exited_screen() -> void:
	current_ball.on_screen_exited.disconnect(on_ball_exited_screen)
	current_ball.queue_free()
	# TODO: Has enough lives?
	respawn_ball()


func respawn_ball() -> void:
	current_ball = ball_scene.instantiate()
	current_ball.disable_collision()
	$Paddle.add_child(current_ball)
	current_ball.position = Vector2(0, -12)
	current_ball.on_screen_exited.connect(on_ball_exited_screen)
	started_game = false


func on_destroy_brick(brick: Brick) -> void:
	spawn_powerup()
	HighscoreManager.add_points(brick.points)
	bricks_available -= 1
	if bricks_available == 0:
		on_level_cleared.emit()


func spawn_powerup() -> void:
	pass
