extends Node

var current_score: int = 0
var highscore: int = 0

signal on_score_updated

func add_points(brick: Brick) -> void:
	var points: int = brick.type.points
	if brick.type.name == "Silver":
		points = brick.type.points * SceneManager.current_level_nr

	current_score += points
	on_score_updated.emit()
