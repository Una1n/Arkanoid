extends Node2D
class_name World

@onready var started_game: bool = false

var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

var current_ball: Ball = null
var bricks_available: int = 100

signal on_level_cleared


func _ready() -> void:
	if OS.is_debug_build():
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	respawn_ball()
	on_level_cleared.connect(SceneManager.go_to_next_level)
	on_level_cleared.connect(PowerupManager.remove_all_powerups)
	HighscoreManager.on_score_updated.connect(on_score_updated)
	bricks_available = get_tree().get_nodes_in_group("Bricks").size()
	for node in get_tree().get_nodes_in_group("Bricks"):
		var brick = node as Brick
		brick.on_destroyed.connect(on_destroy_brick)
		if brick.type.name == "Silver":
			if SceneManager.current_level_nr % 8 == 0:
				brick.type.hits_to_destroy += SceneManager.current_level_nr / 8


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button"):
		if not started_game:
			current_ball.start_moving(Vector2(1, -1))
			current_ball.reparent(self)
			started_game = true

	if OS.is_debug_build() and event.is_action_pressed("debug_next_level"):
		SceneManager.go_to_next_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_prev_level"):
		SceneManager.go_to_prev_level()

	if OS.is_debug_build() and event.is_action_pressed("debug_destroy_bricks"):
		on_level_cleared.emit()


func on_ball_exited_screen(ball: Ball) -> void:
	ball.on_screen_exited.disconnect(on_ball_exited_screen)
	ball.queue_free()

	if get_tree().get_nodes_in_group("Ball").size() == 1:
		PowerupManager.remove_all_powerups()
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
	HighscoreManager.add_points(brick)
	bricks_available -= 1
	if bricks_available == 0:
		on_level_cleared.emit()
	else:
		PowerupManager.spawn_powerup(self, brick)


func on_score_updated() -> void:
	%Score.text = "%s" % HighscoreManager.current_score
