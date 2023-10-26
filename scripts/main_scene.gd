extends Control


func _ready() -> void:
	%NewGameButton.grab_focus()
	_load_settings()


func _load_settings() -> void:
	var user_preferences := UserPreferences.load_or_create()
	AudioManager.set_master_volume(user_preferences.master_audio_level)
	AudioManager.set_music_volume(user_preferences.music_audio_level)
	AudioManager.set_sfx_volume(user_preferences.sfx_audio_level)
	Utils.set_fullscreen(user_preferences.fullscreen)


func _on_new_game_button_pressed() -> void:
	SceneManager.go_to_first_level(scene_file_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	SceneManager.go_to_settings_menu(scene_file_path)
