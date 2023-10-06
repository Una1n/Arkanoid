extends Node2D
class_name Powerup

signal on_screen_exited
signal on_powerup_gained(powerup: Powerup)

var movement_tween: Tween
@onready var points: int = 1000


func _ready() -> void:
	movement_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var start_position = Vector2(global_position.x, 1000)
	movement_tween.tween_property(self, "position", start_position, 5)
	$AnimatedSprite2D.play("default")


func _on_screen_exited() -> void:
	on_screen_exited.emit()
	destroy()


func _on_collected(_body: Node2D) -> void:
	on_powerup_gained.emit(self)
	movement_tween.stop()
	$Sprite2D.visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func is_allowed_to_spawn_powerups_while_active() -> bool:
	return true


func enable_powerup() -> void: pass
func disable_powerup() -> void: pass


func destroy() -> void:
	queue_free()
