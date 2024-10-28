extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var life_timer: Timer = $LifeTimer
@onready var debug_time_label: Label = $DebugTimeLabel
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var points: int = 2

const GRAVITY: float = 160.0
const JUMP: float = -120.0

var _sprite_list: Array[String] = []
var _start_y: float
var _speed_y: float = JUMP


func _ready() -> void: 
	get_initial_y_coord()
	drop_random()


func _process(delta: float) -> void:
	debug_time_label.text = "%02d sec" % life_timer.time_left
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	#if position.y > _start_y:
		#set_process(false)
		#position.y = _start_y
	land_on_plat()


func land_on_plat() -> void: 
	if _speed_y > 0 == true && ray_cast_2d.is_colliding() == true:
		_speed_y = 0


func get_initial_y_coord() -> void:
	_start_y = position.y


func check_sprite_list() -> void: 
	if _sprite_list.size() < 0: 
		return 
	get_sprite_list()


func get_sprite_list() -> void: 
	for sprite_name in animated_sprite_2d.sprite_frames.get_animation_names():
		_sprite_list.push_back(sprite_name)
	#print(_sprite_list)


func drop_random() -> void: 
	check_sprite_list()
	animated_sprite_2d.animation = _sprite_list.pick_random()
	print("selected sprite is ", animated_sprite_2d.animation)


func drop_gone() -> void:
	hide()
	queue_free()


func _on_life_timer_timeout() -> void:
	drop_gone()


func _on_area_entered(_area: Area2D) -> void:
	#print(area)
	SignalManager.on_pickup_hit.emit(points)
	drop_gone()
