extends Resource
class_name BrickType

@export var name: String = "Red"
@export var points: int = 90
@export var hits_to_destroy: int = 1
@export var can_be_destroyed: bool = true
@export var allowed_to_spawn_powerup: bool = true
@export var region_rect: Rect2 = Rect2(0, 0, 32, 16)
