@tool
extends StaticBody2D
class_name Brick


signal on_destroyed(brick: Brick)

@export var type: BrickType:
	set(value):
		type = value
		$Sprite2D.region_rect = value.region_rect

@onready var current_hits: int = 0


func _ready() -> void:
	%AnimatedSprite2D.hide()


func on_collision() -> void:
	if not type.can_be_destroyed:
		%AnimatedSprite2D.show()
		%AnimatedSprite2D.play(type.animation_name)
		return

	current_hits += 1
	if type.hits_to_destroy == current_hits:
		on_destroyed.emit(self)
		queue_free()
	else:
		%AnimatedSprite2D.show()
		%AnimatedSprite2D.play(type.animation_name)
