extends CharacterBody2D

class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT}

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0 
const MAX_FALL: float = 400.0 
const JUMP_VELOCITY: float = -260.0 
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130.0)
const FALLEN_OFF: float = 200.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Node2D = $Shooter
@onready var invincible_player: AnimationPlayer = $InvinciblePlayer
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer

var _state: PlayerState
var _direction: Vector2 = Vector2.RIGHT
var _invincible: bool = false
var _lives: int = 2


func _ready() -> void: 
	call_deferred("setup_player_hearts")


func _physics_process(delta: float) -> void:
	# apply gravity 
	if is_on_floor() == false: 
		velocity.y += GRAVITY * delta 
	# player controls 
	input_movement()
	input_bullet()
	#state_animation()
	sprite_facing_direction()
	update_debug_label()
	calculate_state()
	
	move_and_slide()
	fallen_off()


func setup_player_hearts(): 
	SignalManager.on_game_started.emit(_lives) 


func update_debug_label() -> void: 
	#var label = state_animation()
	debug_label.text = "state: %s, inv: %s \nfloor: %s \nvel: (%.0f, %.0f) \nhearts: %d" % [
		_state, _invincible, is_on_floor(), velocity.x, velocity.y, _lives 
		]


func input_bullet() -> void: 
	if Input.is_action_just_pressed("shoot"):
		#print("pew!")
		shooter.shoot(_direction)


func input_movement() -> void: 
	if _state == PlayerState.HURT:
		return
	
	velocity.x = 0
	
	if Input.is_action_pressed("left") == true: 
		velocity.x -= RUN_SPEED
		set_direction(Vector2.LEFT)
	
	if Input.is_action_pressed("right") == true: 
		velocity.x += RUN_SPEED
		set_direction(Vector2.RIGHT)
	
	if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		SoundManager.play_clip(sfx_player, "jump") 
		velocity.y += JUMP_VELOCITY 
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)


func sprite_facing_direction() -> void:
	var direction = get_direction()
	
	if direction == Vector2.LEFT:
		sprite_2d.flip_h = true 
	elif direction == Vector2.RIGHT:
		sprite_2d.flip_h = false


func state_animation() -> void: 
	#var label: String
	# idle
	if velocity.x == 0:
		animation_player.play("idle")
		#label = "idle"
	# run
	if velocity.x != 0:
		animation_player.play("run")
		#label = "run"
	# jump
	if velocity.y < 0:
		animation_player.play("jump")
		#label = "jump"
	# fall 
	if velocity.y > 0 && is_on_floor() == false:
		animation_player.play("fall")
		#label = "fall"
	# hurt 
	#return label


func set_state(new_state: PlayerState) -> void: 
	if new_state == _state:
		return 
	
	if _state == PlayerState.FALL:
		if (
			new_state == PlayerState.IDLE or 
			new_state == PlayerState.RUN
		):
			SoundManager.play_clip(sfx_player, "land")
	
	_state = new_state
	
	match _state: 
		PlayerState.IDLE: 
			animation_player.play("idle")
		PlayerState.RUN: 
			animation_player.play("run")
		PlayerState.JUMP: 
			animation_player.play("jump")
		PlayerState.FALL: 
			animation_player.play("fall")
		PlayerState.HURT:
			animation_player.play("hurt")
			apply_hurt_jump()


func calculate_state() -> void: 
	# if player is hurt, do nothing
	if _state == PlayerState.HURT:
		return
	
	# if player is on the floor/platform
	if is_on_floor() == true: 
		# on floor - no movement 
		if velocity.x == 0: 
			set_state(PlayerState.IDLE) 
		# on floor - with movement 
		else: 
			set_state(PlayerState.RUN)
	# if player is in the air
	else: 
		# in air - downward
		if velocity.y > 0: 
			set_state(PlayerState.FALL)
		# in air - upward 
		else: 
			set_state(PlayerState.JUMP)


func set_direction(direction: Vector2) -> void: 
	if _direction == direction:
		return
	_direction = direction


func get_direction() -> Vector2: 
	return _direction


func go_invincible() -> void: 
	_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()
	#apply_hurt_jump()


func apply_hurt_jump() -> void: 
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()


func apply_hit() -> void: 
	if _invincible == true:
		return 
	
	SoundManager.play_clip(sfx_player, "damage") 
	
	go_invincible()
	
	if reduce_lives(1) == false:
		return
	
	set_state(PlayerState.HURT)


func reduce_lives(damage: int) -> bool:
	_lives -= damage
	SignalManager.on_player_hit.emit(_lives)
	
	if _lives <= 0: 
		SignalManager.on_game_over.emit()
		SoundManager.play_clip(sfx_player, "game_over") 
		set_physics_process(false)
		animation_player.stop()
		invincible_player.stop()
		print("player game over")
		return false 
	return true 


func fallen_off() -> void: 
	if global_position.y < FALLEN_OFF: 
		return 
	reduce_lives(_lives)


func _on_hitbox_area_entered(_area: Area2D) -> void:
	#print("player just got hit by: ", area)
	apply_hit()


func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()
	#print("invincibility done")


func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE)
	#print("hurt -> idle")
