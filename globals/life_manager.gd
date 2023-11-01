extends Node

var starting_lives: int = 2
var lives: int = 2

signal on_lives_updated(new_value: int)
signal on_respawn
signal on_game_over


func reset_lives() -> void:
	lives = starting_lives


func on_life_lost() -> void:
	if lives > 0:
		remove_life()
		on_respawn.emit()
	else:
		on_game_over.emit()


func add_life() -> void:
	lives += 1
	on_lives_updated.emit(lives)


func remove_life() -> void:
	lives -= 1
	on_lives_updated.emit(lives)
