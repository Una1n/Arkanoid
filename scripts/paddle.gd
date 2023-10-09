extends CharacterBody2D
class_name Paddle

@onready var mouse_position_x: float = get_global_mouse_position().x
@onready var size: int = 64

var laser_mode: bool = false
var laser_cooldown_timer: Timer


func _input(event: InputEvent) -> void:
	# TODO: Keyboard + Controller
	if event is InputEventMouseMotion:
		mouse_position_x = get_global_mouse_position().x


func _process(_delta: float) -> void:
	if not is_instance_valid(laser_cooldown_timer): return

	if Input.is_action_pressed("fire_button") and laser_cooldown_timer.is_stopped():
		shoot_lasers()


func _physics_process(_delta: float) -> void:
	var new_position: Vector2 = Vector2(mouse_position_x - position.x, 0)
	move_and_collide(new_position)


func shoot_lasers() -> void:
	print("Shooting")
	laser_cooldown_timer.start()


func enable_laser_mode() -> void:
	laser_mode = true
	$Sprite2D.region_rect = Rect2(96, 384, 64, 16)
	laser_cooldown_timer = Timer.new()
	laser_cooldown_timer.wait_time = 0.3
	laser_cooldown_timer.one_shot = true
	add_child(laser_cooldown_timer)


func disable_laser_mode() -> void:
	laser_mode = false
	normal_size()
	remove_child(laser_cooldown_timer)
	laser_cooldown_timer = null


func normal_size() -> void:
	size = 64
	$Sprite2D.region_rect = Rect2(96, 400, 64, 16)
	$CollisionMiddle.shape.size = Vector2(64, 16)


func enlarge() -> void:
	size = 96
	$Sprite2D.region_rect = Rect2(256, 400, 96, 16)
	$CollisionMiddle.shape.size = Vector2(96, 16)
	if position.x >= 815 - 17:
		position.x = 815 - 17
	if position.x <= 465 + 17:
		position.x = 465 + 17

