extends CharacterBody2D
class_name Paddle

@onready var mouse_position_x: float = get_global_mouse_position().x
@onready var size: int = 64
@onready var mode: PaddleMode = $NormalMode
@onready var collision_node: CollisionShape2D = $Collision

var non_mouse_movement: bool = true
var move_motion: Vector2 = Vector2.ZERO
const MOVEMENT_SPEED: int = 375

func _ready() -> void:
	mode.enable()


func set_mode(new_mode: PaddleMode) -> void:
	if is_instance_valid(mode):
		mode.disable()
		mode.queue_free()

	mode = new_mode
	add_child(mode)
	mode.enable()


func on_ball_hit(ball: Ball) -> void:
	mode.on_ball_hit(ball)


func play_hit_sfx() -> void:
	AudioManager.play("res://assets/audio/sfx/paddle_ball_hit.wav")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		# Fix for controller trigger: it is seen as mouse motion with no position change
		if motion.relative != Vector2.ZERO:
			mouse_position_x = get_global_mouse_position().x
			non_mouse_movement = false


func _physics_process(delta: float) -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	if dir != 0:
		non_mouse_movement = true

	move_motion = Vector2(dir * MOVEMENT_SPEED, 0) * delta

	if move_motion == Vector2.ZERO and non_mouse_movement == false:
		move_motion = Vector2(mouse_position_x - global_position.x, 0)

	move_and_collide(move_motion)
