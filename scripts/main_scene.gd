extends Control


func _ready() -> void:
	%NewGameButton.grab_focus()


func _on_new_game_button_pressed() -> void:
	SceneManager.go_to_first_level(scene_file_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	SceneManager.go_to_settings_menu(scene_file_path)
