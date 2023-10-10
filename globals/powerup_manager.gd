extends Node
class_name PowerupManager

var POWERUP_LIST: Array[Dictionary] = [
	{
		"scene": preload("res://scenes/powerups/powerup_enlarge.tscn"),
		"roll_weight": 5.0,
		"acc_weight": 0.0
	},
	{
		"scene": preload("res://scenes/powerups/powerup_disruption.tscn"),
		"roll_weight": 4.0,
		"acc_weight": 0.0
	},
	{
		"scene": preload("res://scenes/powerups/powerup_player.tscn"),
		"roll_weight": 2.0,
		"acc_weight": 0.0
	},
	{
		"scene": preload("res://scenes/powerups/powerup_breakout.tscn"),
		"roll_weight": 1.0,
		"acc_weight": 0.0
	},
	{
		"scene": preload("res://scenes/powerups/powerup_slow.tscn"),
		"roll_weight": 4.0,
		"acc_weight": 0.0
	},
	{
		"scene": preload("res://scenes/powerups/powerup_laser.tscn"),
		"roll_weight": 100.0,
		"acc_weight": 0.0
	}
]

var active_powerup: Powerup = null
var powerup_on_screen: bool = false
var powerup_total_weight: float = 0.0

signal on_powerup_activated(powerup: Powerup)


func _ready() -> void:
	powerup_total_weight = 0.0
	for powerup in POWERUP_LIST:
		powerup_total_weight += powerup.roll_weight
		powerup.acc_weight = powerup_total_weight


func spawn_powerup(parent: Node2D, spawn_position: Vector2) -> void:
	if powerup_on_screen: return
	if is_instance_valid(active_powerup) and \
		not active_powerup.is_allowed_to_spawn_powerups_while_active():
		return

	if randi_range(1, 4) == 1:
		var powerup = _get_random_powerup()
		if not is_instance_valid(powerup):
			printerr("Couldn't get powerup from loot table")
			return

		powerup.global_position = spawn_position
		powerup.on_screen_exited.connect(on_powerup_destroyed)
		powerup.on_powerup_gained.connect(on_powerup_gained)
		parent.add_child(powerup)
		powerup_on_screen = true


func _get_random_powerup() -> Powerup:
	var roll: float = randf_range(0.0, powerup_total_weight)
	for powerup in POWERUP_LIST:
		if powerup.acc_weight >= roll:
			return powerup.scene.instantiate() as Powerup

	return null


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
