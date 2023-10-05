extends Node

const POWERUP_LIST: Array[PackedScene] = [
	preload("res://scenes/powerups/powerup_enlarge.tscn"),
	preload("res://scenes/powerups/powerup_disruption.tscn"),
	preload("res://scenes/powerups/powerup_player.tscn")
]

var active_powerup: Powerup = null
var powerup_on_screen: bool = false

signal on_powerup_activated(powerup: Powerup)

func spawn_powerup(parent: Node2D, spawn_position: Vector2) -> void:
	if powerup_on_screen: return
	if is_instance_valid(active_powerup) and \
		not active_powerup.is_allowed_to_spawn_powerups_while_active():
		return

	if randi_range(1, 4) == 1:
		var powerup: Powerup = POWERUP_LIST[randi() % POWERUP_LIST.size()].instantiate()
		powerup.global_position = spawn_position
		powerup.on_screen_exited.connect(on_powerup_destroyed)
		powerup.on_powerup_gained.connect(on_powerup_gained)
		parent.add_child(powerup)
		powerup_on_screen = true


func on_powerup_gained(powerup: Powerup) -> void:
	remove_active_powerup()

	powerup.enable_powerup()
	on_powerup_activated.emit(powerup)
	active_powerup = powerup
	powerup_on_screen = false


func on_powerup_destroyed() -> void:
	powerup_on_screen = false


func remove_active_powerup() -> void:
	if active_powerup == null: return

	active_powerup.disable_powerup()
	active_powerup.queue_free()
	active_powerup = null


func remove_all_powerups() -> void:
	remove_active_powerup()
	if powerup_on_screen:
		get_tree().call_group("Powerup", "destroy")
		powerup_on_screen = false
