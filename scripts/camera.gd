class_name Camera extends Camera2D

@onready var default_camera_position: Vector2 = position


func shake(max_shake_offset: Vector2):
	var random_shake_offset_x: float = randf_range(-max_shake_offset.x, max_shake_offset.x)
	var random_shake_offset_y: float = randf_range(-max_shake_offset.y, max_shake_offset.y)
	var camera_offset: Vector2 = Vector2(random_shake_offset_x, random_shake_offset_y)
	var camera_position: Vector2 = position
	var tween_shake: Tween = create_tween()
	tween_shake.tween_property(self, "position", camera_position + camera_offset, 0.05)
	tween_shake.tween_property(self, "position", camera_position, 0.05)
	tween_shake.tween_property(self, "position", camera_position - camera_offset, 0.05)
	tween_shake.tween_property(self, "position", camera_position, 0.05)
	tween_shake.finished.connect(_shake_finished)


func _shake_finished() -> void:
	position = default_camera_position
