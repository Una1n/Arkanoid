extends Node2D
class_name Gate

signal on_gate_entered


func open() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property($UpperBlock, "scale", Vector2(1, 0.2), 1)
	tween.tween_property($UpperBlock, "position", Vector2(0, -12), 1)
	tween.tween_property($LowerBlock, "scale", Vector2(1, 0.2), 1)
	tween.tween_property($LowerBlock, "position", Vector2(0, 34), 1)
	tween.set_ease(Tween.EASE_IN)
	tween.finished.connect(_enable_collision)
	tween.play()


func close() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property($UpperBlock, "scale", Vector2(1, 1), 1)
	tween.tween_property($UpperBlock, "position", Vector2(0, 0), 1)
	tween.tween_property($LowerBlock, "scale", Vector2(1, 1), 1)
	tween.tween_property($LowerBlock, "position", Vector2(0, 0), 1)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(_disable_collision)
	tween.play()


func _enable_collision() -> void:
	$NextLevelHitbox/CollisionShape2D.set_deferred("disabled", false)


func _disable_collision() -> void:
	$NextLevelHitbox/CollisionShape2D.set_deferred("disabled", true)


func _on_next_level_hitbox_collision(_body: Node2D) -> void:
	on_gate_entered.emit()
