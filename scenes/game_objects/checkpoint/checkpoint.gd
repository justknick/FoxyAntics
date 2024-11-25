extends Area2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var checkpoint_sound: AudioStreamPlayer2D = $CheckpointSound


func _ready() -> void: 
	SignalManager.on_boss_defeated.connect(on_boss_defeated)



func on_boss_defeated(_points: int) -> void: 
	monitoring = true 
	animation_tree[TRIGGER_CONDITION] = true
	SoundManager.play_clip(checkpoint_sound, "checkpoint")


func _on_area_entered(area: Area2D) -> void:
	SoundManager.play_clip(checkpoint_sound, "win")
	print("level completed!") 
