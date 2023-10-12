extends Node

const SAVEFILE: String = "user://highscore.sav"

var current_score: int = 0
var highscore: int = 0
var new_highscore: bool = false

signal on_score_updated
signal on_highscore_updated


func _ready() -> void:
	_load_highscore()


func _load_highscore() -> void:
	if FileAccess.file_exists(SAVEFILE):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		if file:
			highscore = file.get_64()
			file.close()


func save_highscore() -> void:
	if new_highscore:
		var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
		if file:
			file.store_64(highscore)
			file.close()


func reset_score() -> void:
	current_score = 0
	new_highscore = false


func _add_points(points: int) -> void:
	current_score += points
	on_score_updated.emit()

	if current_score > highscore:
		highscore = current_score
		new_highscore = true
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
