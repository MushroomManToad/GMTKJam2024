extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var to_toggle : ITogglable

var pressed : int = 0

var pushed_texture = preload("res://sprites/game_objects/button_on.png")
var unpushed_texture = preload("res://sprites/game_objects/button_off.png")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func send_activation_signal():
	to_toggle._add_power(1)
	audio_stream_player_2d.play()

func send_deactivation_signal():
	to_toggle._add_power(-1)
	audio_stream_player_2d.play()

func _on_detection_region_body_entered(body: Node2D) -> void:
	if body is Player or body is IPushableObject or body is MimicEnemy:
		if pressed == 0:
			sprite_2d.set_texture(pushed_texture)
			send_activation_signal()
		pressed = pressed + 1


func _on_detection_region_body_exited(body: Node2D) -> void:
	if body is Player or body is IPushableObject or body is MimicEnemy:
		pressed = pressed - 1
	if pressed == 0:
		sprite_2d.set_texture(unpushed_texture)
		send_deactivation_signal()
