extends CharacterBody2D

class_name EnemyBase

const OFF_SCREEN_REMOVE: float = 200.0

@export var points: int = 1

var _player_ref: Player
var _gravity: float = 800.0 
var _dying: bool = false 


func _ready() -> void: 
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if _player_ref == null:
		print("no player reference") 
		return


func _physics_process(delta: float) -> void:
	fallen_off()


func fallen_off() -> void: 
	if global_position.y >= OFF_SCREEN_REMOVE:
		queue_free()


func defeat() -> void: 
	if _dying == true:
		return 
	
	#below also plays sounds, pickups, and explosions
	_dying = true 
	set_physics_process(false)
	hide()
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	defeat()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	# frog starts jumping, eagle starts flying
	pass
