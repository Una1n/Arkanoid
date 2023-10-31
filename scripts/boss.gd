class_name Boss extends StaticBody2D

signal on_destroyed()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_sprite: Sprite2D = $HitSprite
@onready var hit_timer: Timer = $HitTimer
@onready var shoot_cd_timer: Timer = $ShootCDTimer
@onready var mouth_open_timer: Timer = $MouthOpenTimer
@onready var current_hits: int = 0
@onready var is_being_destroyed: bool = false


func _ready() -> void:
	hit_sprite.hide()
	animated_sprite.play("default")
	shoot_cd_timer.timeout.connect(_on_start_shooting)
	mouth_open_timer.timeout.connect(_on_stop_shooting)
	shoot_cd_timer.start()


func on_collision() -> void:
	if is_being_destroyed: return

	current_hits += 1
	if current_hits == 16:
		_destroy()
	else:
		_on_hit()


func _on_start_shooting() -> void:
	animated_sprite.play("start_open_mouth")
	await animated_sprite.animation_finished
	animated_sprite.play("open_mouth")
	# TODO: Start shooting
	mouth_open_timer.start()


func _on_stop_shooting() -> void:
	animated_sprite.play("start_close_mouth")
	await animated_sprite.animation_finished
	animated_sprite.play("default")
	shoot_cd_timer.start()


func _on_hit() -> void:
	hit_sprite.show()
	AudioManager.play("res://assets/audio/sfx/brick_indestructable.wav")
	hit_timer.start(0.3)
	await hit_timer.timeout
	hit_sprite.hide()


func _destroy() -> void:
	is_being_destroyed = true
#	animated_sprite.hide()
#	$CollisionShape2D.set_deferred("disabled", true)
#	AudioManager.play("res://assets/audio/sfx/brick_destroyed.wav")
#	animation_player.play("destroy_left")
#	on_destroyed.emit(self)
#	await animation_player.animation_finished
	queue_free()
