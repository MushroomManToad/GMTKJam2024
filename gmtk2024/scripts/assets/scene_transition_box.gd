extends Area2D

## The scene to load
@export var scene_id : String
## Load location relative to previous scene's load location
@export var scene_load_location : Vector2
## Position in new scene player should jump to relative to origin
@export var player_jump_target : Vector2
## Target relative to new scene for camera floor
@export var camera_base : int

var curr_camera_base : int

var animation_timer : float = 0.0
var animating : bool = false

var player : Player
var camera_2d : Camera2D

var loaded : bool = false

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Set vars
		player = body as Player
		camera_2d = player.camera_2d
		curr_camera_base = camera_2d.limit_bottom
		# Start animation
		animating = true

func _process(delta: float) -> void:
	if animating:
		animation_timer += delta
		# 1 sec, zoom out camera
		if animation_timer <= 1.0:
			player.freeze()
			var scale_var : float = 3.0 - (animation_timer * 2.0)
			camera_2d.zoom = Vector2(scale_var, scale_var)
			camera_2d.limit_bottom = ((curr_camera_base as float) + ((Game_Manager.loaded_floors_nodes[1].global_position[1] + scene_load_location[1] + camera_base as float) - (curr_camera_base as float)) * (animation_timer)) as int
			if animation_timer >= 0.5:
				Game_Manager.ftw_ui.animation_player.play("fade_to_white")
				if not audio_stream_player_2d.playing:
					audio_stream_player_2d.play()
		# 0.5 sec, fade to white
		elif animation_timer <= 1.5:
			pass
		# Load screen and move up player
		elif animation_timer <= 2.0:
			if not loaded:
				Game_Manager.load_new_scene(scene_load_location, scene_id, player_jump_target)
				player.global_position = Game_Manager.loaded_floors_nodes[0].global_position + scene_load_location + player_jump_target
				loaded = true
				Game_Manager.ftw_ui.animation_player.play("fade_from_white")
		# fade from white and zoom back in camera
		elif animation_timer <= 3.0:
			var scale_var : float = 1.0 + ((animation_timer - 2.0) * 2.0)
			camera_2d.zoom = Vector2(scale_var, scale_var)
		else:
			player.unfreeze()
			queue_free()
