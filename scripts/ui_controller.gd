class_name UIController extends CanvasLayer

@export var powerup_manager: PowerupManager
@export var life_texture: PackedScene
@export var lives_container: HFlowContainer
@export var score_label: Label
@export var highscore_label: Label
@export var rounds_label: Label
@export var powerup_container: VBoxContainer
@export var powerup_label: Label


func initialize() -> void:
	on_score_updated()
	on_highscore_updated()
	on_rounds_updated()
	on_powerup_updated(null)

	HighscoreManager.on_score_updated.connect(on_score_updated)
	HighscoreManager.on_highscore_updated.connect(on_highscore_updated)
	LifeManager.on_lives_updated.connect(on_lives_updated)
	powerup_manager.on_powerup_activated.connect(on_powerup_updated)
	powerup_manager.on_powerup_deactivated.connect(on_powerup_updated.bind(null))

	for i in LifeManager.lives:
		lives_container.add_child(life_texture.instantiate())


func on_lives_updated() -> void:
	var ui_lives_count: int = lives_container.get_child_count()
	if ui_lives_count < LifeManager.lives:
		lives_container.add_child(life_texture.instantiate())
	elif ui_lives_count > LifeManager.lives:
		if ui_lives_count > 0:
			var life = lives_container.get_child(ui_lives_count - 1)
			lives_container.remove_child(life)


func on_score_updated() -> void:
	score_label.text = "%s" % HighscoreManager.current_score


func on_highscore_updated() -> void:
	highscore_label.text = "%s" % HighscoreManager.highscore


func on_rounds_updated() -> void:
	rounds_label.text = "%s" % SceneManager.current_level_nr


func on_powerup_updated(powerup: Powerup) -> void:
	if is_instance_valid(powerup):
		powerup_container.show()
		powerup_label.text = "%s" % powerup.display_name
	else:
		powerup_container.hide()
