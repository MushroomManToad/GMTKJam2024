class_name GameManager

extends Node

@onready var game = $"/root/Game/"
var player : Player

const player_asset = preload("res://scenes/player/player.tscn")

func _ready():
	# TODO Functions to be run to setup game after all scenes have been loaded.
	load_scene(Vector2(0,48), "kristen_test_scene")
	load_player(Vector2(0,0))
	pass

# Generic Stage Loading Function
func load_scene(pos: Vector2, scene_id: String):
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
	game.add_child(stage_instance)

func load_player(pos: Vector2) -> void:
	var player_instance : CharacterBody2D = player_asset.instantiate()
	player_instance.global_position = pos
	game.add_child(player_instance)
