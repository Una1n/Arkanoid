class_name BossProjectile extends Area2D


@export var speed = 250

var direction: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_collision(body: Node2D) -> void:
	if body is Paddle:
		var paddle := body as Paddle
		paddle.destroy()

	destroy()


func destroy() -> void:
	queue_free()


func _on_screen_exited() -> void:
	destroy()
