@tool
class_name Brick extends StaticBody2D

signal on_destroyed(brick: Brick)

@export var type: BrickType:
	set(value):
		type = value
		$Sprite2D.region_rect = value.region_rect

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_hits: int = 0
@onready var is_being_destroyed: bool = false

func _ready() -> void:
	animated_sprite.hide()


func on_collision() -> void:
	if is_being_destroyed: return

	if not type.can_be_destroyed:
		_on_hit_indestructable()
		return

	current_hits += 1
	if type.hits_to_destroy == current_hits:
		_destroy()
	else:
		_on_hit_indestructable()


func _on_hit_indestructable() -> void:
	animated_sprite.show()
	animated_sprite.play(type.animation_name)
	animation_player.play("hit_indestructable")
	AudioManager.play("res://assets/audio/sfx/brick_indestructable.wav")


func _destroy() -> void:
	is_being_destroyed = true
	animated_sprite.hide()
	$Sprite2D.z_index = 100
	$Sprite2D.z_as_relative = false
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play("res://assets/audio/sfx/brick_destroyed.wav")
	if randi_range(1, 2) == 1:
		animation_player.play("destroy_left")
	else:
		animation_player.play("destroy_right")
	on_destroyed.emit(self)
	await animation_player.animation_finished
	queue_free()
