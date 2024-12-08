extends Control

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var heart_h_box: HBoxContainer = $MarginContainer/HBoxContainer/HeartHBox
@onready var color_rect: ColorRect = $ColorRect
@onready var level_complete: VBoxContainer = $ColorRect/LevelComplete
@onready var game_over: VBoxContainer = $ColorRect/GameOver

var _hearts: Array = []


func _ready() -> void: 
	on_score_update(ScoreManager.get_score())
	_hearts = heart_h_box.get_children()
	SignalManager.on_player_hit.connect(update_hearts_display)
	SignalManager.on_game_started.connect(update_hearts_display)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_update.connect(on_score_update)


func _process(delta: float) -> void:
	game_over_controls()


func game_over_controls() -> void: 
	if game_over.visible == true:
		if Input.is_action_just_pressed("jump"):
			GameManager.load_main_scene()


func on_score_update(score: int) -> void: 
	score_label.text = "%05d" % score


func update_hearts_display(lives: int) -> void: 
	for heart in range(_hearts.size()):
		_hearts[heart].visible = lives > heart 


func on_game_over() -> void: 
	color_rect.show()
	game_over.show()
