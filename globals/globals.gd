extends Node

var current_score: int = 0
var highscore: int = 0

func add_points(points: int) -> void:
	current_score += points
