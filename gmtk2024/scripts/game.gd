class_name Game

extends Node2D

@onready var music: AudioStreamPlayer2D = $music
const BOSS_FIGHT_03 = preload("res://sound/boss_fight_03.wav")

func _process(delta : float):
	if not music.playing:
		music.play
