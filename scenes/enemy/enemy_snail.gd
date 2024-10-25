extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_detection: RayCast2D = $FloorDetection

@export var speed: float = 30.0 


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	edge_detect()
	
	if is_on_floor() == false:
		falling(delta)
	else:
		on_ground_movement()
	
	move_and_slide()


func falling(delta: float) -> void: 
	velocity.y += _gravity * delta
	#if is_on_floor() == false:
		#velocity.y += _gravity * delta


func on_ground_movement() -> void: 
	velocity.x = speed if animated_sprite_2d.flip_h == true else -speed


func turn_around() -> void: 
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x = -floor_detection.position.x


func edge_detect() -> void: 
	if is_on_wall() == true || floor_detection.is_colliding() == false:
			turn_around()
