extends CharacterBody2D


const __SPEED = 400.0


func start_moving() -> void:
	velocity = Vector2(1, -1) * __SPEED


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is Brick:
			var brick = collision.get_collider() as Brick
			brick.on_collided_with_ball()

		if collision.get_collider() is Paddle:
			var paddle = collision.get_collider() as Paddle
			var paddle_pos: Vector2 = collision.get_position() - paddle.global_position
			paddle_pos.x /= paddle.size
			paddle_pos.normalized()

			# If we hit the middle part of the paddle it reflects normally
			var degrees: float = clampf(paddle_pos.x * 75, -75, 75)
			if paddle_pos.x > -0.2 and paddle_pos.x < 0 and velocity.normalized().x > 0:
				degrees = absf(degrees)
			elif paddle_pos.x >= 0 and paddle_pos.x < 0.2 and velocity.normalized().x < 0:
				degrees *= -1

			# On the edge of the paddle it will go at a sharper angle
			var reflect_vector: Vector2 = Vector2.UP.rotated(deg_to_rad(degrees))
			velocity = reflect_vector * __SPEED
			move_and_collide(reflect_vector * delta)
			return

		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(reflect * delta)
