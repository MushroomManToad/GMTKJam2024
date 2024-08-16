class_name GameManager

extends Node

@onready var game = $"/root/Game/"

func _ready():
	# TODO Functions to be run to setup game after all scenes have been loaded.
	load_scene(Vector2(0,48), "dev_stage")
	pass

# Generic Stage Loading Function
func load_scene(pos: Vector2, scene_id: String):
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
	game.add_child(stage_instance)
