extends AnimatableBody2D

@export var platform_destination: Marker2D
@export var speed: float  = 50.0

var _start: Vector2
var _end: Vector2
var _time_to_move: float = 0.0 
var _tween: Tween 


func _ready() -> void: 
	calculate_variables() 
	set_platform_motion()


func calculate_variables() -> void:
	_start = global_position
	_end = platform_destination.global_position
	
	var distance: float = _start.distance_squared_to(_end)
	#print("distance, ", distance)
	_time_to_move = distance / speed 
	#print("time to move ", _time_to_move)


func set_platform_motion() -> void: 
	_tween = get_tree().create_tween()
	_tween.set_loops()
	
	_tween.tween_property(self, "global_position", _end, _time_to_move)
	_tween.tween_property(self, "global_position", _start, _time_to_move)


func _exit_tree() -> void: 
	# override the exit tree, which is invoked when scene is removed from stree 
	if _tween: 
		_tween.kill()
