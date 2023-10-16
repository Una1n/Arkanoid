extends CharacterBody2D
class_name Ball

const __SPEED = 350.0

@onready var powerup_slow_active = false
var current_direction: Vector2

signal on_screen_exited(ball: Ball)


func _ready() -> void:
	add_to_group("Ball")


func start_moving(direction: Vector2) -> void:
	current_direction = direction.normalized()
	velocity = current_direction * __SPEED


func _physics_process(delta: float) -> void:
	if position.y >= 520:
		set_collision_mask_value(2, false)

	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var collision_body = collision.get_collider()
		var bounce_velocity: Vector2 = velocity.bounce(collision.get_normal())
		if collision_body.has_method("on_collision"):
			collision_body.on_collision()

		if collision.get_collider() is Paddle:
			var paddle = collision.get_collider() as Paddle
			var paddle_pos: Vector2 = collision.get_position() - paddle.global_position
			paddle_pos.x /= (paddle.size / 2)
			paddle_pos.normalized()

			# If we hit the middle part of the paddle it reflects normally
			var degrees: float = clampf(paddle_pos.x * 75, -75, 75)
			if paddle_pos.x > -0.2 and paddle_pos.x < 0 and velocity.normalized().x > 0:
				degrees = absf(degrees)
			elif paddle_pos.x >= 0 and paddle_pos.x < 0.2 and velocity.normalized().x < 0:
				degrees *= -1

			# On the edge of the paddle it will go at a sharper angle
			current_direction = Vector2.UP.rotated(deg_to_rad(degrees))
			velocity = current_direction * bounce_velocity.length()

			paddle.on_ball_hit(self)
		else:
			current_direction = bounce_velocity.normalized()

			# Making sure the ball horizontal movement is never within a 5 degree angle
			# Otherwise it may get stuck going only horizontal
			var angle = rad_to_deg(collision.get_normal().angle_to(bounce_velocity))
			if angle > -5 and angle < 5 and collision.get_normal() != Vector2.DOWN:
				var offset_angle: float
				if angle > 0:
					offset_angle = rad_to_deg(current_direction.angle()) + 10
				else:
					offset_angle = rad_to_deg(current_direction.angle()) - 10
				current_direction = Vector2.from_angle(deg_to_rad(offset_angle))

			velocity = current_direction * bounce_velocity.length()

		_move_ball(delta)


func _move_ball(delta: float) -> void:
	if powerup_slow_active:
		velocity *= randf_range(1.01, 1.05)
	if velocity != Vector2.ZERO:
		move_and_collide(velocity * delta)


func normal_speed() -> void:
	velocity = current_direction * __SPEED
	powerup_slow_active = false


func slow_speed() -> void:
	velocity /= 2
	powerup_slow_active = true


func _on_screen_exited() -> void:
	on_screen_exited.emit(self)


func disable_collision(disable: bool = true) -> void:
	$CollisionShape2D.disabled = disable
