extends Control


func _ready() -> void:
	%NewLabel.hide()
	%ScoreLabel.text = "Score: %s" % HighscoreManager.current_score
	%HighScoreLabel.text = "Highscore: %s" % HighscoreManager.highscore
	if HighscoreManager.new_highscore:
		$AnimationPlayer.play("new_highscore")


func _on_restart_button_pressed() -> void:
	SceneManager.go_to_first_level()


func _on_quit_button_pressed() -> void:
	SceneManager.go_to_main_menu()