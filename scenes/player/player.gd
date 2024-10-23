extends CharacterBody2D

class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT}

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0 
const MAX_FALL: float = 400.0 
const JUMP_VELOCITY: float = -260.0 

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel

var _state: PlayerState

func _ready() -> void: 
	pass 


func _physics_process(delta: float) -> void:
	# apply gravity 
	if is_on_floor() == false: 
		velocity.y += GRAVITY * delta 
	# player controls 
	input_movement()
	#state_animation()
	get_facing_direction()
	update_debug_label()
	calculate_state()
	
	input_bullet()
	
	move_and_slide()


func update_debug_label() -> void: 
	#var label = state_animation()
	debug_label.text = "state: %s, \nfloor: %s \nvel: (%.0f, %.0f)" % [
		_state, is_on_floor(), velocity.x, velocity.y
		]


func input_bullet() -> void: 
	if Input.is_action_just_pressed("shoot"):
		#print("pew!")
		SignalManager.on_create_bullet.emit(global_position, Vector2(50,50), 3.0, 20.0, Constants.ObjectType.BULLET_PLAYER)


func input_movement() -> void: 
	velocity.x = 0
	
	if Input.is_action_pressed("left") == true: 
		velocity.x -= RUN_SPEED
	
	if Input.is_action_pressed("right") == true: 
		velocity.x += RUN_SPEED
	
	if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += JUMP_VELOCITY 
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)


func get_facing_direction() -> void:
	if velocity.x < 0:
		sprite_2d.flip_h = true 
	elif velocity.x > 0: 
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


func calculate_state() -> void: 
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
