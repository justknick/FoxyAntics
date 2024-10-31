extends Node

const SOUNDS_BOSS_ARRIVE = "boss_arrive"
const SOUNDS_CHECKPOINT = "checkpoint"
const SOUNDS_DAMAGE = "damage" #
const SOUNDS_MUSIC_1 = "music_1"
const SOUNDS_MUSIC_2 = "music_2"
const SOUNDS_GAME_OVER = "game_over" #
const SOUNDS_IMPACT = "impact"
const SOUNDS_JUMP = "jump" #
const SOUNDS_LAND = "land"
const SOUNDS_LASER = "laser"
const SOUNDS_KILL = "kill"
const SOUNDS_PICKUP = "pickup"
const SOUNDS_YOU_WIN = "win" 

var SOUND_LIBRARY = {
	SOUNDS_BOSS_ARRIVE: preload("res://assets/sound/boss_arrive.wav"), 
	SOUNDS_CHECKPOINT: preload("res://assets/sound/checkpoint.wav"), 
	SOUNDS_DAMAGE: preload("res://assets/sound/damage.wav"), 
	SOUNDS_MUSIC_1: preload("res://assets/sound/Farm Frolics.ogg"), 
	SOUNDS_MUSIC_2: preload("res://assets/sound/Flowing Rocks.ogg"), 
	SOUNDS_GAME_OVER: preload("res://assets/sound/game_over.ogg"), 
	SOUNDS_IMPACT: preload("res://assets/sound/impact.wav"), 
	SOUNDS_JUMP: preload("res://assets/sound/jump.wav"), 
	SOUNDS_LAND: preload("res://assets/sound/land.wav"), 
	SOUNDS_LASER: preload("res://assets/sound/laser.wav"), 
	SOUNDS_KILL: preload("res://assets/sound/pickup5.ogg"), 
	SOUNDS_PICKUP: preload("res://assets/sound/pickup.wav"), 
	SOUNDS_YOU_WIN: preload("res://assets/sound/you_win.ogg"), 
}


func play_clip(player: AudioStreamPlayer2D, key: String) -> void: 
	if SOUND_LIBRARY.has(key) == false:
		return 
	player.stream = SOUND_LIBRARY[key]
	player.play()
