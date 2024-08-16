class_name GameManager

extends Node

func _ready():
	# TODO Functions to be run to setup game after all scenes have been loaded.
	print("Hello World")
	pass


func load_scene(pos: Vector2, scene_id: String):
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
