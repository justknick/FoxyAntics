extends Control

@export var HighScoreLabel: PackedScene

@onready var grid_container: GridContainer = $MarginContainer/GridContainer


func _ready() -> void: 
	display_scores()
	pass
	print("current scene: ", GameManager.get_current_scene)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()



func display_scores() -> void: 
	# clear grid container 
	for score in grid_container.get_children():
		grid_container.remove_child(score)
	
	# get scores
	for score_record in ScoreManager.get_score_history():
		var create_label: Label = HighScoreLabel.instantiate()
		create_label.text = "%04d" % score_record
		grid_container.add_child(create_label)
	pass 
