extends Control

@export var HighScoreLabel: PackedScene

@onready var grid_container: GridContainer = $MarginContainer/GridContainer


func _ready() -> void: 
	display_scores()
	pass



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
