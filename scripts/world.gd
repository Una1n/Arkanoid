extends Node2D

@onready var started_game: bool = false

var current_bricks_count: int = 100

func _ready() -> void:
	current_bricks_count = get_tree().get_nodes_in_group("Bricks").size()
	for node in get_tree().get_nodes_in_group("Bricks"):
		var brick = node as Brick
		# TODO
		pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_button"):
		if not started_game:
			$Paddle/Ball.start_moving()
			$Paddle/Ball.reparent(self)
			started_game = true

	if OS.is_debug_build() and event.is_action_pressed("debug_next_level"):
		SceneManager.go_to_next_level()
