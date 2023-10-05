extends Node2D
class_name World

var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

@onready var started_game: bool = false

var current_ball: Ball = null
var bricks_available: int = 100

signal on_level_cleared
signal on_life_lost
signal on_spawn_powerup(parent: Node2D, spawn_position: Vector2)


func _ready() -> void:
	if OS.is_debug_build():
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	respawn_ball()
	_connect_signals()
	bricks_available = get_tree().get_nodes_in_group("Bricks").size()
	for node in get_tree().get_nodes_in_group("Bricks"):
		var brick = node as Brick
		brick.on_destroyed.connect(on_destroy_brick)
		brick.on_destroyed.connect(HighscoreManager.add_points)
		if brick.type.name == "Silver":
			if SceneManager.current_level_nr % 8 == 0:
				brick.type.hits_to_destroy += SceneManager.current_level_nr / 8.0


func _connect_signals() -> void:
	on_level_cleared.connect(SceneManager.go_to_next_level)
	on_level_cleared.connect(PowerupManager.remove_all_powerups)
	on_life_lost.connect(PowerupManager.remove_all_powerups)
	on_life_lost.connect(LifeManager.on_life_lost)
	on_spawn_powerup.connect(PowerupManager.spawn_powerup)
	HighscoreManager.on_score_updated.connect(on_score_updated)
	LifeManager.on_lives_updated.connect(on_lives_updated)
	LifeManager.on_respawn.connect(respawn_ball)


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
	ball.tree_exited.connect(handle_life_lost)
	ball.queue_free()


func handle_life_lost() -> void:
	if get_tree().get_nodes_in_group("Ball").size() == 0:
		on_life_lost.emit()


func respawn_ball() -> void:
	current_ball = ball_scene.instantiate()
	current_ball.disable_collision()
	$Paddle.add_child(current_ball)
	current_ball.position = Vector2(0, -12)
	current_ball.on_screen_exited.connect(on_ball_exited_screen)
	started_game = false


func on_destroy_brick(brick: Brick) -> void:
	bricks_available -= 1
	if bricks_available == 0:
		on_level_cleared.emit()
	elif brick.type.allowed_to_spawn_powerup:
		on_spawn_powerup.emit(self, brick.global_position)


func on_lives_updated() -> void:
	%Lives.text = "%s" % LifeManager.lives


func on_score_updated() -> void:
	%Score.text = "%s" % HighscoreManager.current_score
