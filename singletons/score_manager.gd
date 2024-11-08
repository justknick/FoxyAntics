extends Node

const SCORE_SAVE_DATA: String = "user://FoxySave.json"
const MAX_SCORE_ENTRY = 10

var _score: int = 0
var _score_history: Array = []


func _ready() -> void: 
	SignalManager.on_enemy_hit.connect(update_score)
	SignalManager.on_pickup_hit.connect(update_score)
	SignalManager.on_game_over.connect(on_game_over)
	load_save_data()


func load_save_data() -> void: 
	_score_history.clear()
	var file = FileAccess.open(SCORE_SAVE_DATA, FileAccess.READ)
	if file: 
		var text: String = file.get_as_text()
		if text && text.length() > 0: 
			_score_history = JSON.parse_string(file.get_as_text())
		#else: 
			#print("save found, but with no text ")
		file.close()
	else: 
		print("no save found. creating save file..")
		save_score()
	
	_score_history.sort_custom(compare_scores)
	print("loaded scores ", _score_history)


func compare_scores(a, b): 
	# will sort list in decending order
	return b.score < a.score 


func save_score() -> void: 
	_score_history.sort_custom(compare_scores)
	var file = FileAccess.open(SCORE_SAVE_DATA, FileAccess.WRITE)
	if file: 
		file.store_string(JSON.stringify(_score_history.slice(0, MAX_SCORE_ENTRY)))
		file.close() 
	print("score saved")


func update_score(points: int) -> void: 
	_score += points
	SignalManager.on_score_update.emit(_score)


func on_game_over() -> void: 
	_score_history.append({"score": _score})
	print("score(s) are ", _score_history)
	save_score()


func reset_score() -> void: 
	_score = 0


func get_score() -> int: 
	return _score
