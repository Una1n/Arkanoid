@tool
class_name Brick extends StaticBody2D

signal on_destroyed(brick: Brick)

@export var type: BrickType:
	set(value):
		type = value
		$Sprite2D.region_rect = value.region_rect

@export var animation_player: AnimationPlayer

@onready var current_hits: int = 0


func _ready() -> void:
	%AnimatedSprite2D.hide()


func on_collision() -> void:
	if not type.can_be_destroyed:
		%AnimatedSprite2D.show()
		%AnimatedSprite2D.play(type.animation_name)
		animation_player.play("hit_indestructable")
		AudioManager.play("res://assets/audio/sfx/brick_indestructable.wav")
		return

	current_hits += 1
	if type.hits_to_destroy == current_hits:
		AudioManager.play("res://assets/audio/sfx/brick_destroyed.wav")
		on_destroyed.emit(self)
		_destroy()
	else:
		%AnimatedSprite2D.show()
		%AnimatedSprite2D.play(type.animation_name)
		animation_player.play("hit_indestructable")
		AudioManager.play("res://assets/audio/sfx/brick_indestructable.wav")


func _destroy() -> void:
	queue_free()
