extends Control

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var heart_h_box: HBoxContainer = $MarginContainer/HBoxContainer/HeartHBox
@onready var color_rect: ColorRect = $ColorRect
@onready var level_complete: VBoxContainer = $ColorRect/LevelComplete
@onready var game_over: VBoxContainer = $ColorRect/GameOver

var _hearts: Array = []


func _ready() -> void: 
	_hearts = heart_h_box.get_children()
	SignalManager.on_player_hit.connect(update_hearts_display)
	SignalManager.on_game_started.connect(update_hearts_display)


func update_hearts_display(lives: int) -> void: 
	for heart in range(_hearts.size()):
		_hearts[heart].visible = lives > heart 
