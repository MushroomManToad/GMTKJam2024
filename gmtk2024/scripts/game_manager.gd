class_name GameManager

extends Node

@onready var game = $"/root/Game/"
var player : Player
var background : ParallaxBackground
var ui : UI_Screen

const player_asset = preload("res://scenes/player/player.tscn")
const background_asset = preload("res://scenes/global/background.tscn")
const UI_BATTLE_SCREEN = preload("res://scenes/player/ui_battle_screen.tscn")

# Current array of loaded floor objects
var loaded_floors : Array
var loaded_floors_nodes : Array

# Signal for syncing UI
signal health_update
signal spell_update

func _ready():
	load_first_stage(Vector2(0, 0), "kristen_test_scene")

# Generic Stage Loading Function. Called by relevant functions "first and "new
func load_scene(pos: Vector2, scene_id: String) -> Node2D:
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
	game.add_child(stage_instance)
	return stage_instance

func load_player(pos: Vector2) -> void:
	var player_instance : CharacterBody2D = player_asset.instantiate()
	player_instance.global_position = pos
	game.add_child(player_instance)
	player = player_instance

func load_background(_pos: Vector2) -> void:
	var bg_instance : ParallaxBackground = background_asset.instantiate()
	game.add_child(bg_instance)
	background = bg_instance

func load_ui() -> void:
	var ui_instance : UI_Screen = UI_BATTLE_SCREEN.instantiate()
	ui_instance.player = player
	game.add_child(ui_instance)
	ui = ui_instance

func load_new_scene(pos: Vector2, scene_id: String):
	# A lil crash failsafe
	if loaded_floors[1] is Floor:
		# Load the new scene
		var new_scene : Node2D = load_scene(pos + (loaded_floors[1] as Floor).get_vals()[0], scene_id)
		
		# Unload any scene 2+ scenes ago
		if not loaded_floors[0] == null and loaded_floors_nodes[0] is Node2D:
			(loaded_floors_nodes[0] as Node2D).queue_free()
		
		# Push current scene to prev scene
		loaded_floors[0] = loaded_floors[1]
		loaded_floors_nodes[0] = loaded_floors_nodes[1]
		
		# Load new floor
		loaded_floors[1] = Floor.new(pos + (loaded_floors[1] as Floor).get_vals()[0], scene_id)
		loaded_floors_nodes[1] = new_scene
	else:
		printerr("Major floor error. Blame MMT and tell him he typecast wrong")

# Special variable setting for loading the tower's first floor
func load_first_stage(pos: Vector2, scene_id: String):
	load_background(Vector2(0, 0))
	var new_scene : Node2D = load_scene(pos, scene_id)
	load_player(Vector2(0,0))
	loaded_floors = [null, Floor.new(pos, scene_id), null]
	loaded_floors_nodes = [null, new_scene, null]
	load_ui()

# Internal class for storing loaded floor data
class Floor:
	var scene_id : String
	var pos : Vector2
	
	func _init(pos_: Vector2, s_id: String) -> void:
		self.scene_id = s_id
		self.pos = pos_
	
	# Returns an array of [Pos, Scene_ID]
	func get_vals() -> Array:
		return [pos, scene_id]
	
	func _to_string() -> String:
		return "(" + str(pos) + ", " + str(scene_id) + ")"
