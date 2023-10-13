extends CharacterBody2D
class_name Paddle

@onready var mouse_position_x: float = get_global_mouse_position().x
@onready var size: int = 64

var non_mouse_movement: bool = true
var move_motion: Vector2 = Vector2.ZERO
const MOVEMENT_SPEED: int = 10

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position_x = get_global_mouse_position().x
		non_mouse_movement = false


func _physics_process(_delta: float) -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	if dir != 0:
		non_mouse_movement = true

	move_motion = Vector2(dir * MOVEMENT_SPEED, 0)

	if move_motion == Vector2.ZERO and non_mouse_movement == false:
		move_motion = Vector2(mouse_position_x - global_position.x, 0)

	move_and_collide(move_motion)


func normal_size() -> void:
	size = 64
	$Sprite2D.region_rect = Rect2(96, 400, 64, 16)
	$CollisionMiddle.shape.size = Vector2(64, 16)


func enlarge() -> void:
	size = 96
	$CollisionMiddle.shape.size = Vector2(96, 16)
	$Sprite2D.region_rect = Rect2(256, 400, 96, 16)
	if position.x >= 175 - 17:
		position.x = 175 - 17
	if position.x <= -175 + 17:
		position.x = -175 + 17
