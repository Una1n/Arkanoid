extends Node

var particle_scenes: Array[PackedScene] = [
	preload("res://effects/hit_particles.tscn")
]

func _ready() -> void:
	for particle_scene in particle_scenes:
		var particle = particle_scene.instantiate() as GPUParticles2D
		particle.one_shot = true
		particle.emitting = true
		add_child(particle)
		particle.position = Vector2(-50, -50)
