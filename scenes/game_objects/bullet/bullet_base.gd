extends Area2D

class_name Bullet

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 5.0 
var _life_time: float = 0.0


#func _ready() -> void: 
	#setup(global_position, Vector2.RIGHT, 10.0, 10.0)


func _process(delta: float) -> void:
	position += _direction * delta 
	check_bullet_life_span(delta)


func check_bullet_life_span(delta: float) -> void: 
	# increment the lifetime by the delta
	_life_time += delta
	# once the lifetime reaches lifespan, bullet will disappear
	if _life_time > _life_span:
		queue_free()
		#print("bullet gone")


func setup(pos: Vector2, direction: Vector2, speed: float, lifespan: float) -> void: 
	_direction = direction.normalized() * speed 
	_life_span = lifespan
	global_position = pos


func _on_area_entered(_area: Area2D) -> void:
	#print("bullet hit ", area)
	queue_free()
