extends CharacterBody2D

class_name EnemyBase

const OFF_SCREEN_REMOVE: float = 200.0

var _player_ref: Player
var _gravity: float = 800.0 
var _dying: bool = false 


func _ready() -> void: 
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)


func fallen_off() -> void: 
	if global_position.y >= OFF_SCREEN_REMOVE:
		queue_free()


func defeat() -> void: 
	if _dying == true:
		return 
	
	#below also plays sounds and explosions
	_dying = true 
	set_physics_process(false)
	hide()
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	defeat()
