class_name PaddleLaser extends Paddle

@onready var left_muzzle_position: Vector2 = $LeftBulletMuzzle.position
@onready var right_muzzle_position: Vector2 = $RightBulletMuzzle.position

@export var laser_fire_rate: float = 0.3

var laser_scene: PackedScene = preload("res://scenes/laser.tscn")

var laser_cooldown_timer: Timer


func _ready() -> void:
	laser_cooldown_timer = Timer.new()
	laser_cooldown_timer.wait_time = laser_fire_rate
	laser_cooldown_timer.one_shot = true
	add_child(laser_cooldown_timer)


func _process(_delta: float) -> void:
	if not is_instance_valid(laser_cooldown_timer): return

	if Input.is_action_pressed("fire_button") and laser_cooldown_timer.is_stopped():
		shoot()


func shoot() -> void:
	var left_laser = _create_laser()
	var right_laser = _create_laser()
	left_laser.position = left_muzzle_position + global_position
	right_laser.position = right_muzzle_position + global_position
	laser_cooldown_timer.start()


func _create_laser() -> Laser:
	var world = get_tree().get_first_node_in_group("World") as World
	var laser = laser_scene.instantiate()
	world.add_child(laser)
	return laser


func disable() -> void:
	normal_size()
	laser_cooldown_timer.queue_free()
	laser_cooldown_timer = null
