@tool
extends Node2D
class_name Brick

enum Colors {RED = 0, YELLOW, PINK, ORANGE, CYAN, GREEN, BLUE, VIOLET, SILVER, GOLD}

signal on_destroyed

@export var color: Colors = Colors.RED:
	set(value):
		color = value
		_update_color()

var points: int = 90
var hits_to_destroy: int = 1
var can_be_destroyed: bool = true

@onready var current_hits: int = 0

func _update_color() -> void:
	if color == Colors.RED:
		$Sprite2D.region_rect = Rect2(0, 0, 32, 16)
		points = 90
		hits_to_destroy = 1
	elif color == Colors.YELLOW:
		$Sprite2D.region_rect = Rect2(0, 64, 32, 16)
		points = 120
		hits_to_destroy = 1
	elif color == Colors.ORANGE:
		$Sprite2D.region_rect = Rect2(0, 48, 32, 16)
		points = 60
		hits_to_destroy = 1
	elif color == Colors.CYAN:
		$Sprite2D.region_rect = Rect2(0, 16, 32, 16)
		points = 70
		hits_to_destroy = 1
	elif color == Colors.GREEN:
		$Sprite2D.region_rect = Rect2(0, 32, 32, 16)
		points = 80
		hits_to_destroy = 1
	elif color == Colors.BLUE:
		$Sprite2D.region_rect = Rect2(0, 144, 32, 16)
		points = 100
		hits_to_destroy = 1
	elif color == Colors.VIOLET:
		$Sprite2D.region_rect = Rect2(0, 80, 32, 16)
		points = 110
		hits_to_destroy = 1
	elif color == Colors.SILVER:
		$Sprite2D.region_rect = Rect2(0, 96, 32, 16)
		points = 50 #* stage_number # TODO!
		hits_to_destroy = 2
	elif color == Colors.GOLD:
		$Sprite2D.region_rect = Rect2(0, 112, 32, 16)
		can_be_destroyed = false
	elif color == Colors.PINK:	# White in original game
		$Sprite2D.region_rect = Rect2(0, 128, 32, 16)
		points = 50
		hits_to_destroy = 1

func on_collided_with_ball() -> void:
	if not can_be_destroyed: return

	current_hits += 1
	if hits_to_destroy == current_hits:
		Globals.add_points(points)
		on_destroyed.emit()
		queue_free()
