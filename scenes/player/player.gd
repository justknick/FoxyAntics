extends CharacterBody2D

class_name Player

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0 
const MAX_FALL: float = 400.0 
const JUMP_VELOCITY: float = -260.0 

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void: 
	pass 


func _physics_process(delta: float) -> void:
	if is_on_floor() == false: 
		velocity.y += GRAVITY * delta 
	
	input_movement()
	state_animation()
	get_facing_direction()
	
	move_and_slide()


func input_movement() -> void: 
	velocity.x = 0
	
	if Input.is_action_pressed("left") == true: 
		velocity.x = -RUN_SPEED
	
	if Input.is_action_pressed("right") == true: 
		velocity.x = RUN_SPEED
	
	if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY 
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)



func get_facing_direction() -> void:
	if velocity.x < 0:
		sprite_2d.flip_h = true 
	elif velocity.x > 0: 
		sprite_2d.flip_h = false 


func state_animation() -> void: 
	# idle
	if velocity.x == 0:
		animation_player.play("idle")
	# run
	if velocity.x != 0:
		animation_player.play("run")
	# jump
	if velocity.y < 0:
		animation_player.play("jump")
	# fall 
	if velocity.y > 0 && is_on_floor() == false:
		animation_player.play("fall")
	# hurt 
	
