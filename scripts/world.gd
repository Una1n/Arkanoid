extends Node2D
class_name World

var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
var life_texture: PackedScene = preload("res://scenes/life_texture.tscn")

@onready var started_game: bool = false
@export var gate: Gate
@export var powerup_manager: PowerupManager
@export var paddle_position: Node2D
@export var current_paddle: Paddle

var debug_manager: DebugManager
var current_ball: Ball = null
var bricks_available: int = 100

signal on_level_cleared
signal on_life_lost


func _ready() -> void:
	if OS.is_debug_build():
		debug_manager = DebugManager.new(self)
		debug_manager.name = "DebugManager"
		add_child(debug_manager)
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	Input.warp_mouse(paddle_position.position)
	respawn_ball()
	_initialize_ui()
	_connect_signals()

	bricks_available = get_tree().get_nodes_in_group("Bricks").size()
	for node in get_tree().get_nodes_in_group("Bricks"):
		var brick := node as Brick
		if not brick.type.can_be_destroyed:
			bricks_available -= 1
			continue

		brick.on_destroyed.connect(on_destroy_brick)
		brick.on_destroyed.connect(HighscoreManager.add_brick_points)
		if brick.type.name == "Silver" and SceneManager.current_level_nr % 8 == 0:
			brick.type.hits_to_destroy += SceneManager.current_level_nr / 8


func _initialize_ui() -> void:
	on_score_updated()
	on_highscore_updated()
	on_rounds_updated()

	for i in LifeManager.lives:
		%LivesTextureContainer.add_child(life_texture.instantiate())


func _connect_signals() -> void:
	gate.on_gate_entered.connect(on_entered_gate)
	on_level_cleared.connect(SceneManager.go_to_next_level)
	on_life_lost.connect(LifeManager.on_life_lost)
	HighscoreManager.on_score_updated.connect(on_score_updated)
	HighscoreManager.on_highscore_updated.connect(on_highscore_updated)
	LifeManager.on_lives_updated.connect(on_lives_updated)
	LifeManager.on_respawn.connect(respawn_ball, CONNECT_DEFERRED)
	LifeManager.on_game_over.connect(on_game_over)
	powerup_manager.on_powerup_activated.connect(HighscoreManager.add_powerup_points)
	if not SceneManager.on_load_first_level.is_connected(HighscoreManager.reset_score):
		SceneManager.on_load_first_level.connect(HighscoreManager.reset_score)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if not SceneManager.in_transition:
				_pause_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button") and not started_game:
		current_ball.start_moving(Vector2(0.7, -1))
		current_ball.reparent(self)
		started_game = true

	# TODO: Handle when we have other menus open
	if event.is_action_pressed("ui_cancel"):
		_pause_game()


func _pause_game() -> void:
	get_tree().paused = true
	%PauseMenu.show()


func on_game_over() -> void:
	HighscoreManager.save_highscore()
	SceneManager.go_to_game_over()


func on_entered_gate() -> void:
	HighscoreManager.add_gate_points()
	on_level_cleared.emit()


func on_ball_exited_screen(ball: Ball) -> void:
	ball.tree_exited.connect(handle_life_lost)
	ball.queue_free()


func handle_life_lost() -> void:
	if get_tree().get_nodes_in_group("Ball").size() == 0:
		powerup_manager.remove_all_powerups()
		on_life_lost.emit()


func respawn_ball() -> void:
	current_ball = ball_scene.instantiate() as Ball
	current_paddle.add_child(current_ball)
	current_ball.position = Vector2(0, -12)
	current_ball.on_screen_exited.connect(on_ball_exited_screen)
	started_game = false


func change_paddle(paddle: Paddle) -> void:
	current_paddle = paddle


func on_destroy_brick(brick: Brick) -> void:
	bricks_available -= 1
	if bricks_available == 0:
		on_level_cleared.emit()
	elif brick.type.allowed_to_spawn_powerup:
		powerup_manager.spawn_powerup(brick.global_position)


func on_lives_updated() -> void:
	var ui_lives_count: int = %LivesTextureContainer.get_child_count()
	if ui_lives_count < LifeManager.lives:
		%LivesTextureContainer.add_child(life_texture.instantiate())
	elif ui_lives_count > LifeManager.lives:
		if ui_lives_count > 0:
			var life = %LivesTextureContainer.get_child(ui_lives_count - 1)
			%LivesTextureContainer.remove_child(life)


func on_score_updated() -> void:
	%Score.text = "%s" % HighscoreManager.current_score


func on_highscore_updated() -> void:
	%HighScore.text = "%s" % HighscoreManager.highscore


func on_rounds_updated() -> void:
	%Rounds.text = "%s" % SceneManager.current_level_nr
