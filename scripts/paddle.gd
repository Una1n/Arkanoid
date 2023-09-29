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
