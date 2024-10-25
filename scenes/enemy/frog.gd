extends EnemyBase

const JUMP_VELOCITY_X: float = 100.0
const JUMP_VELOCITY_Y: float = 150.0
const JUMP_VELOCITY_LEFT: Vector2 = Vector2(-JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)
const JUMP_VELOCITY_RIGHT: Vector2 = Vector2(JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)

@export var jump_timer_min: float = 2.0 
@export var jump_timer_max: float = 4.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

var _jump: bool = false
var _player_detected: bool = false 


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_on_floor() == false:
		gravity(delta)
	else:
		on_ground()
	
	check_jump()
	move_and_slide()


func gravity(delta: float) -> void: 
	velocity.y += _gravity * delta


func on_ground() -> void: 
	velocity.x = 0
	animated_sprite_2d.play("idle")
	face_player()


func check_jump() -> void:
	if is_on_floor() == false:
		return 
	if _player_detected == false or _jump == false:
		return 
	apply_jump()


func apply_jump() -> void:
	if animated_sprite_2d.flip_h == false:
		velocity = JUMP_VELOCITY_LEFT
	elif animated_sprite_2d.flip_h == true:
		velocity = JUMP_VELOCITY_RIGHT
	
	animated_sprite_2d.play("jump")
	start_timer()


func face_player() -> void: 
	if (_player_ref.global_position > self.global_position && \
			animated_sprite_2d.flip_h == false):
		animated_sprite_2d.flip_h = true
	elif (_player_ref.global_position < self.global_position && \
			animated_sprite_2d.flip_h == true):
		animated_sprite_2d.flip_h = false


func start_timer() -> void: 
	_jump = false
	jump_timer.wait_time = randf_range(jump_timer_min, jump_timer_max)
	jump_timer.start()
	#print("timer starts ", jump_timer.wait_time)


func _on_jump_timer_timeout() -> void:
	#print("timer ends")
	_jump = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("i dont sees player...")
	_player_detected = false
	jump_timer.stop()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("i sees player!!")
	_player_detected = true
	start_timer()
	# add logic to face player
	#face_player()
