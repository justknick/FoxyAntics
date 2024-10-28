extends Node2D
# object will instantiate ("spawn") a 'game object' with the type associated 

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/game_objects/bullet/bullet_player.tscn"), 
	Constants.ObjectType.BULLET_ENEMY: preload("res://scenes/game_objects/bullet/bullet_enemy.tscn"),   
	Constants.ObjectType.EXPLOSION: preload("res://scenes/game_objects/explosion/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://scenes/game_objects/fruit_pickup/fruit_pickup.tscn"),
}


func _ready() -> void: 
	SignalManager.on_create_bullet.connect(on_create_bullet)
	SignalManager.on_create_object.connect(on_create_object)


func on_create_bullet(pos: Vector2, direction: Vector2, speed: float, lifespan: float, type: Constants.ObjectType) -> void: 
	if !OBJECT_SCENES.has(type):
		print("no object type exists for  ", type)
		return 
	
	#print("creating pew")
	var new_bullet: Bullet = OBJECT_SCENES[type].instantiate()
	new_bullet.setup(pos, direction, speed, lifespan)
	
	call_deferred("add_child", new_bullet)


func on_create_object(pos: Vector2, type: Constants.ObjectType) -> void: 
	if !OBJECT_SCENES.has(type):
		print("no object type exists for  ", type)
		return 
	
	var new_object = OBJECT_SCENES[type].instantiate()
	new_object.global_position = pos
	call_deferred("add_child", new_object)
