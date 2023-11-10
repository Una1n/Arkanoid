class_name PowerupManager extends Node


signal on_powerup_activated(powerup: Powerup)
signal on_powerup_deactivated

@export var powerup_list: Array[PowerupData] = []

var active_powerup: Powerup = null
var powerup_on_screen: bool = false
var powerup_total_weight: float = 0.0

@onready var powerup_not_dropped_counter: int = 0


func _ready() -> void:
	powerup_total_weight = 0.0
	for powerup in powerup_list:
		powerup_total_weight += powerup.roll_weight
		powerup.acc_weight = powerup_total_weight


func spawn_powerup(spawn_position: Vector2) -> void:
	if powerup_on_screen: return
	if is_instance_valid(active_powerup) and \
		not active_powerup.is_allowed_to_spawn_powerups_while_active():
		return

	if randi_range(1, 3) == 1 or powerup_not_dropped_counter >= 4:
		powerup_not_dropped_counter = 0
		var powerup = _get_random_powerup()
		if not is_instance_valid(powerup):
			printerr("Couldn't get powerup from drop table")
			return

		powerup.global_position = spawn_position
		powerup.on_screen_exited.connect(on_powerup_destroyed)
		powerup.on_powerup_gained.connect(on_powerup_gained, CONNECT_DEFERRED)
		add_child(powerup)
		powerup_on_screen = true
	else:
		powerup_not_dropped_counter += 1


func _get_random_powerup() -> Powerup:
	var roll: float = randf_range(0.0, powerup_total_weight)
	for powerup in powerup_list:
		if powerup.acc_weight >= roll:
			return powerup.scene.instantiate() as Powerup

	return null


func on_powerup_gained(powerup: Powerup) -> void:
	remove_active_powerup()

	AudioManager.play("res://assets/audio/sfx/powerup_gained.wav")
	powerup.enable_powerup()
	active_powerup = powerup
	powerup_on_screen = false
	on_powerup_activated.emit(powerup)


func on_powerup_destroyed() -> void:
	powerup_on_screen = false


func remove_active_powerup() -> void:
	if active_powerup == null: return

	active_powerup.disable_powerup()
	active_powerup.queue_free()
	active_powerup = null
	on_powerup_deactivated.emit()


func remove_all_powerups() -> void:
	remove_active_powerup()
	get_tree().call_group("Projectiles", "destroy")
	if powerup_on_screen:
		get_tree().call_group("Powerup", "destroy")
		powerup_on_screen = false
