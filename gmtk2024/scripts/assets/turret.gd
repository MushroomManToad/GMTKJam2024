extends Node2D

@export var shot_speed : float
@export var shot_cd : float

var shot_timer : float = 0.0

const FORB = preload("res://scenes/game_objects/forb.tscn")

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	# Check if line of sight to player
	var player : Player = Game_Manager.player
	var player_center : Vector2 = player.global_position + Vector2(0.0, -6.0)
	
	
	var direction = (player_center - self.global_position).normalized()
	
	# If so, fire on a timer
	shot_timer -= delta
	if shot_timer <= 0.0:
		shoot(direction)
		shot_timer = shot_cd

func shoot(direction : Vector2):
	audio_stream_player_2d.play()
	var forb_instance = FORB.instantiate()
	forb_instance.global_position = self.global_position
	forb_instance.direction = direction
	forb_instance.speed = shot_speed
	Game_Manager.game.add_child(forb_instance)
