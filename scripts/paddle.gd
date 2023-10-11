extends CharacterBody2D
class_name Paddle

@onready var mouse_position_x: float = get_global_mouse_position().x
@onready var size: int = 64


func _input(event: InputEvent) -> void:
	# TODO: Keyboard + Controller
	if event is InputEventMouseMotion:
		mouse_position_x = get_global_mouse_position().x


func _physics_process(_delta: float) -> void:
	var new_position: Vector2 = Vector2(mouse_position_x - global_position.x, 0)
	move_and_collide(new_position)


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
