class_name GameManager

extends Node

@onready var game = $"/root/Game/"
var player : Player
var background : ParallaxBackground

const player_asset = preload("res://scenes/player/player.tscn")
const background_asset = preload("res://scenes/global/background.tscn")

# Current array of loaded floor objects
var loaded_floors : Array = [null, null, null]

func _ready():
	load_first_stage(Vector2(0, 0), "kristen_test_scene")

# Generic Stage Loading Function. Called by relevant functions "first and "new
func load_scene(pos: Vector2, scene_id: String):
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
	game.add_child(stage_instance)

func load_player(pos: Vector2) -> void:
	var player_instance : CharacterBody2D = player_asset.instantiate()
	player_instance.global_position = pos
	game.add_child(player_instance)
	player = player_instance

func load_background(pos: Vector2) -> void:
	var bg_instance : ParallaxBackground = background_asset.instantiate()
	game.add_child(bg_instance)
	background = bg_instance

func load_new_scene(pos: Vector2, scene_id: String):
	pass

# Special variable setting for loading the tower's first floor
func load_first_stage(pos: Vector2, scene_id: String):
	load_background(Vector2(0, 0))
	load_scene(pos, scene_id)
	load_player(Vector2(0,0))
	# Array setup
	pass

# Internal class for storing loaded floor data
class Floor:
	var scene_id : String
	var pos : Vector2
	
	func set_vals(pos: Vector2, scene_id: String) -> void:
		self.scene_id = scene_id
		self.pos = pos
	
	# Returns an array of [Pos, Scene_ID]
	func get_vals() -> Array:
		return [pos, scene_id]
