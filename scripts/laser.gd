extends Area2D
class_name Laser

@export var speed = 300


func _process(delta: float) -> void:
	position += Vector2.UP * speed * delta


func _on_collision(body: Node2D) -> void:
	if body.has_method("on_collision"):
		body.on_collision()
	queue_free()


func destroy() -> void:
	queue_free()
