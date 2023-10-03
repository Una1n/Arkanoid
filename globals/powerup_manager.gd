extends Node

const POWERUP_LIST: Array[PackedScene] = [
	preload("res://scenes/powerups/powerup_enlarge.tscn"),
	preload("res://scenes/powerups/powerup_disruption.tscn")
]

var active_powerup: Powerup = null
var powerup_on_screen: bool = false


func spawn_powerup(world: World, brick: Brick) -> void:
	if powerup_on_screen: return
	if active_powerup is PowerupDisruption and \
		get_tree().get_nodes_in_group("Ball").size() > 1:
			return
	if brick.type.name == "Silver": return

	if randi_range(1, 5) == 1:
		var powerup: Powerup = POWERUP_LIST[randi() % POWERUP_LIST.size()].instantiate()
		powerup.global_position = brick.global_position
		powerup.on_screen_exited.connect(on_powerup_destroyed)
		powerup.on_powerup_gained.connect(on_powerup_gained)
		world.add_child(powerup)
		powerup_on_screen = true


func on_powerup_gained(powerup: Powerup) -> void:
	remove_active_powerup()

	powerup.enable_powerup()
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
