extends Node

var lives: int = 2

signal on_lives_updated
signal on_respawn
signal on_game_over


func on_life_lost() -> void:
	remove_life()
	if lives >= 0:
		on_respawn.emit()
	else:
		on_game_over.emit()


func add_life() -> void:
	lives += 1
	on_lives_updated.emit()


func remove_life() -> void:
	lives -= 1
	on_lives_updated.emit()
