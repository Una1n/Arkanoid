extends GPUParticles2D

@export var remove_timer: Timer

func _ready() -> void:
	remove_timer.start(lifetime)


func _on_remove_timer_timeout() -> void:
	queue_free()
