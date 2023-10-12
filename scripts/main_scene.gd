extends Control


func _on_new_game_button_pressed() -> void:
	SceneManager.go_to_first_level()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
