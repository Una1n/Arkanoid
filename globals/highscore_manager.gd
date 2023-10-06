extends Node

var current_score: int = 0
var highscore: int = 0

signal on_score_updated
signal on_highscore_updated


func _add_points(points: int) -> void:
	current_score += points
	on_score_updated.emit()

	if current_score > highscore:
		highscore = current_score
		on_highscore_updated.emit()


func add_gate_points() -> void:
	_add_points(10000)


func add_powerup_points(powerup: Powerup) -> void:
	_add_points(powerup.points)


func add_brick_points(brick: Brick) -> void:
	var points: int = brick.type.points
	if brick.type.name == "Silver":
		points = brick.type.points * SceneManager.current_level_nr

	_add_points(points)
