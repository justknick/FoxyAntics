extends Node2D
class_name Shooter

@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

@export var speed: float = 50.0 
@export var life_span: float = 10.0 
@export var bullet_key: Constants.ObjectType 
@export var shoot_delay: float = 0.7 

var _can_shoot: bool = true 

func _ready() -> void: 
	shoot_timer.wait_time = shoot_delay


func shoot(direction: Vector2) -> void: 
	# shoot will not be invoked if false 
	if _can_shoot == false:
		return 
	
	_can_shoot = false
	SignalManager.on_create_bullet.emit(global_position, direction, speed, life_span, bullet_key)
	shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
