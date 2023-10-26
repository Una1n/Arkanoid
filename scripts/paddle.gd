class_name Paddle extends CharacterBody2D


@export var mode: PaddleMode
@export var collision_node: CollisionShape2D

@onready var mouse_position_x: float = get_global_mouse_position().x
@onready var size: int = 64

var non_mouse_movement: bool = true
var move_motion: Vector2 = Vector2.ZERO
const MOVEMENT_SPEED: int = 375

func _ready() -> void:
	mode.enable()


func set_mode(new_mode: PaddleMode) -> void:
	if is_instance_valid(mode):
		mode.disable()
		mode.queue_free()

	mode = new_mode
	add_child(mode)
	mode.enable()


func on_ball_hit(ball: Ball, collision: KinematicCollision2D) -> void:
	var paddle_pos: Vector2 = collision.get_position() - global_position
	paddle_pos.x /= (size / 2)
	paddle_pos.normalized()

	# If we hit the middle part of the paddle it reflects normally
	var degrees: float = clampf(paddle_pos.x * 75, -75, 75)
	if paddle_pos.x > -0.2 and paddle_pos.x < 0 and velocity.normalized().x > 0:
		degrees = absf(degrees)
	elif paddle_pos.x >= 0 and paddle_pos.x < 0.2 and velocity.normalized().x < 0:
		degrees *= -1

	# On the edge of the paddle the ball will go at a sharper angle
	ball.current_direction = Vector2.UP.rotated(deg_to_rad(degrees))
	ball.velocity = ball.current_direction * ball.velocity.bounce(collision.get_normal()).length()

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(mode, "scale", Vector2(1, 1), 0.2).from(Vector2(1.5, 0.7))
	tween.set_ease(Tween.EASE_OUT)
	tween.play()
	mode.on_ball_hit(ball)


func play_hit_sfx() -> void:
	AudioManager.play("res://assets/audio/sfx/paddle_ball_hit.wav")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		# Fix for controller trigger: it is seen as mouse motion with no position change
		if motion.relative != Vector2.ZERO:
			mouse_position_x = get_global_mouse_position().x
			non_mouse_movement = false


func _physics_process(delta: float) -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	if dir != 0:
		non_mouse_movement = true

	move_motion = Vector2(dir * MOVEMENT_SPEED, 0) * delta

	if move_motion == Vector2.ZERO and non_mouse_movement == false:
		move_motion = Vector2(mouse_position_x - global_position.x, 0)

	move_and_collide(move_motion)
