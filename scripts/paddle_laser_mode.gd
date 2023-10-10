class_name PaddleLaser extends Paddle

@onready var left_muzzle_position: Vector2 = $LeftBulletMuzzle.position
@onready var right_muzzle_position: Vector2 = $RightBulletMuzzle.position

@export var laser_fire_rate: float = 0.3

var laser_mode: bool = false
var laser_cooldown_timer: Timer


func _ready() -> void:
	laser_mode = true
	laser_cooldown_timer = Timer.new()
	laser_cooldown_timer.wait_time = laser_fire_rate
	laser_cooldown_timer.one_shot = true
	add_child(laser_cooldown_timer)


func _process(_delta: float) -> void:
	if not is_instance_valid(laser_cooldown_timer): return

	if Input.is_action_pressed("fire_button") and laser_cooldown_timer.is_stopped():
		shoot()


func shoot() -> void:
	print("Shooting")
	laser_cooldown_timer.start()


func disable() -> void:
	laser_mode = false
	normal_size()
	remove_child(laser_cooldown_timer)
	laser_cooldown_timer = null
