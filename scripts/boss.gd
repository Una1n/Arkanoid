class_name Boss extends StaticBody2D

signal on_destroyed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mouth_marker: Marker2D = $MouthMarker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_sprite: Sprite2D = $HitSprite
@onready var hit_timer: Timer = $HitTimer
@onready var shoot_cd_timer: Timer = $ShootCDTimer
@onready var mouth_open_timer: Timer = $MouthOpenTimer
@onready var current_hits: int = 0
@onready var is_being_destroyed: bool = false

@export var projectile_scene: PackedScene

var paddle: Paddle = null

func _ready() -> void:
	paddle = get_tree().get_first_node_in_group("Paddle") as Paddle
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
	mouth_open_timer.start()
	shoot_projectiles()


func shoot_projectiles() -> void:
	animation_player.play("shoot_projectiles")


func _shoot_projectile() -> void:
	var projectile := projectile_scene.instantiate() as BossProjectile
	projectile.position = mouth_marker.position
	add_child(projectile)
	projectile.direction = projectile.global_position.direction_to(paddle.global_position)
	projectile.look_at(paddle.global_position)


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
	HighscoreManager.add_boss_hit_points()


func _destroy() -> void:
	is_being_destroyed = true
	get_tree().paused = true
	get_tree().call_group("Projectiles", "destroy")
	animation_player.play("death")
	await animation_player.animation_finished
	get_tree().paused = false
	SceneManager.go_to_victory_screen(scene_file_path)
