extends Control


var paused_mouse_position: Vector2


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_resume_game()
		accept_event()


func _on_resume_button_pressed() -> void:
	_resume_game()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.go_to_main_menu()


func _resume_game() -> void:
	Input.warp_mouse(paused_mouse_position)
	hide()
	get_tree().paused = false


func _on_visibility_changed() -> void:
	if visible:
		paused_mouse_position = get_global_mouse_position()
