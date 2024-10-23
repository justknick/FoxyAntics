extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/bullet/bullet_player.tscn"), 
	Constants.ObjectType.BULLET_ENEMY: preload("res://scenes/bullet/bullet_enemy.tscn"),   
}


func _ready() -> void: 
	SignalManager.on_create_bullet.connect(on_create_bullet)


func on_create_bullet(pos: Vector2, direction: Vector2, speed: float, lifespan: float, type: Constants.ObjectType) -> void: 
	if !OBJECT_SCENES.has(type):
		print("no object type exists for  ", type)
		return 
	
	#print("creating pew")
	var new_bullet: Bullet = OBJECT_SCENES[type].instantiate()
	new_bullet.setup(pos, direction, speed, lifespan)
	
	call_deferred("add_child", new_bullet)
