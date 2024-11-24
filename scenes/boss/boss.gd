extends Node2D
# when hurt, travel to any states in state machine
# consider giving boss invinsibility during "arrive" animation

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visual: Node2D = $Visual

var _is_invinsible: bool = false 


func trigger() -> void: 
	pass 


func tween_hit() -> void: 
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1.6)
	


func set_invinsible(flag: bool) -> void: 
	# when enemy boss takes hit, go invinsible
	# invinsible will become false at end of hurt animation in AnimationPlayer
	_is_invinsible = flag
	if flag == true: 
		state_machine.travel("hurt")


func take_damage() -> void: 
	if _is_invinsible == true: 
		return 
	set_invinsible(true)
	print("Boss: ouch")
	tween_hit()


func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	# when area (player bullet) enters the hurtbox > take hit, go invinsible 
	take_damage() 
