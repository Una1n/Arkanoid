extends Node

var current_score: int = 0
var highscore: int = 0
var bricks_available: int = 100

signal on_level_cleared

func _ready() -> void:
	Globals.on_level_cleared.connect(SceneManager.go_to_next_level)


func add_points(points: int) -> void:
	current_score += points


func destroy_brick(brick: Brick) -> void:
	add_points(brick.points)
	bricks_available -= 1
	if bricks_available == 0:
		on_level_cleared.emit()
