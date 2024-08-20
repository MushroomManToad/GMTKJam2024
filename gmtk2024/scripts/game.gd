class_name Game

extends Node2D

@onready var music: AudioStreamPlayer2D = $music 
const BOSS_FIGHT_03 = preload("res://sound/boss_fight_03.wav")

func _process(delta : float):
	pass

func stop_music():
	music.stop()

func play_boss_music():
	if not music.playing or not music.stream == BOSS_FIGHT_03:
		music.stream = BOSS_FIGHT_03
		music.play()
