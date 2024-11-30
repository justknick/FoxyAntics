extends Node2D


func _ready() -> void: 
	SignalManager.on_game_over.connect(on_game_over)
	print("current scene: ", GameManager.get_current_scene)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance"):
		GameManager.load_next_level_scene()
		print("there is now cow level!")
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()


func on_game_over() -> void: 
	#get all moveable objects to freeze 
	for moveable in get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP):
		#print("freezing ", moveable)
		moveable.set_physics_process(false)
		moveable.set_process(false)
 
