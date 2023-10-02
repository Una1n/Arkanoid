extends CharacterBody2D
class_name Paddle

var mouse_position_x: int

@onready var size: int = 32


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position_x = event.position.x


func _physics_process(_delta: float) -> void:
	var new_position: Vector2 = Vector2(mouse_position_x - position.x, 0)
	move_and_collide(new_position)


func normal_size() -> void:
	$Sprite2D.region_rect = Rect2(96, 400, 64, 16)
	$CollisionMiddle.shape.size = Vector2(66, 16)


func enlarge() -> void:
	$Sprite2D.region_rect = Rect2(256, 400, 96, 16)
	$CollisionMiddle.shape.size = Vector2(98, 16)
	if position.x >= 815 - 17:
		position.x = 815 - 17
	if position.x <= 465 + 17:
		position.x = 465 + 17

