extends Node2D


func _ready() -> void: 
	SignalManager.on_game_over.connect(on_game_over)


func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
		#print("pew!")
		#SignalManager.on_create_bullet.emit(Vector2(50,50), Vector2(50,50), 3.0, 20.0, Constants.ObjectType.BULLET_PLAYER)
	pass


func on_game_over() -> void: 
	#get all moveable objects to freeze 
	for moveable in get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP):
		print("freeing ", moveable)
		moveable.set_physics_process(false)
		moveable.set_process(false)
 
