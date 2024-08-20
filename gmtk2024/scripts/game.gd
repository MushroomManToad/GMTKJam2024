class_name Game

extends Node2D

@onready var music: AudioStreamPlayer2D = $music 
const BOSS_FIGHT_03 = preload("res://sound/boss_fight_03.wav")
const A_WORTHY_CHALLENGE__LOOP_ = preload("res://sound/A Worthy Challenge (LOOP).wav")
const JUMP_AND_SHOOT_MAN__LOOP_ = preload("res://sound/Jump and Shoot Man (LOOP).wav")

func stop_music():
	music.stop()

func play_boss_music():
	if not music.playing or not music.stream == BOSS_FIGHT_03:
		music.volume_db = -5.0
		music.stream = BOSS_FIGHT_03
		music.play()

func play_stage_3_4_music():
	if not music.playing or not music.stream == A_WORTHY_CHALLENGE__LOOP_:
		music.stop()
		music.volume_db = 0.0
		music.stream = A_WORTHY_CHALLENGE__LOOP_
		music.play()

func play_stage_1_2_music():
	if not music.playing or not music.stream == JUMP_AND_SHOOT_MAN__LOOP_:
		music.stop()
		music.volume_db = -10.0
		music.stream = JUMP_AND_SHOOT_MAN__LOOP_
		music.play()
