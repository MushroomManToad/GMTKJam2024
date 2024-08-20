class_name GameManager

extends Node

@onready var game = $"/root/Game/"
var player : Player
var background : ParallaxBackground
var ui : UI_Screen
var ftw_ui : FTW_UI_Screen

const player_asset = preload("res://scenes/player/player.tscn")
const background_asset = preload("res://scenes/global/background.tscn")
const UI_BATTLE_SCREEN = preload("res://scenes/player/ui_battle_screen.tscn")
const UI_FADE_TO_WHITE = preload("res://scenes/player/ui_fade_to_white.tscn")
const INTRO_SCENE = preload("res://scenes/cutscenes/IntroScene.tscn")
const TITLE = preload("res://scenes/title.tscn")

# Current array of loaded floor objects
var loaded_floors : Array
var loaded_floors_nodes : Array

# Signal for syncing UI
signal health_update
signal spell_update

func _ready():
	# Comment this out for release
	#load_first_stage(Vector2(0, 0), "kristen_test_scene", Vector2(0.0, -16.0))
	
	# Load Title Screen
	var title_instance = TITLE.instantiate()
	game.add_child(title_instance)

# Called on start button press
func start_game():
	play_intro()
	# Unload title screen

func play_intro():
	var intro = INTRO_SCENE.instantiate()
	game.add_child(intro)

func load_playable_game():
	load_first_stage(Vector2(0.0, 0), "stage_1", Vector2(-16.0, 0.0))

# Generic Stage Loading Function. Called by relevant functions "first and "new
func load_scene(pos: Vector2, scene_id: String, _prs_loc: Vector2) -> Node2D:
	var stage = load("res://scenes/stages/" + scene_id + ".tscn")
	var stage_instance : Node2D = stage.instantiate()
	stage_instance.global_position = pos
	game.call_deferred("add_child", stage_instance)
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
	
	var ftw_instance : FTW_UI_Screen = UI_FADE_TO_WHITE.instantiate()
	game.add_child(ftw_instance)
	ftw_ui = ftw_instance

func load_new_scene(pos: Vector2, scene_id: String, prs_loc: Vector2):
	# A lil crash failsafe
	if loaded_floors[1] is Floor:
		# Load the new scene
		var new_scene : Node2D = load_scene(pos + (loaded_floors[1] as Floor).get_vals()[0], scene_id, prs_loc)
		
		# Unload any scene 2+ scenes ago
		if not loaded_floors[0] == null and loaded_floors_nodes[0] is Node2D:
			(loaded_floors_nodes[0] as Node2D).queue_free()
		
		# Push current scene to prev scene
		loaded_floors[0] = loaded_floors[1]
		loaded_floors_nodes[0] = loaded_floors_nodes[1]
		
		# Load new floor
		loaded_floors[1] = Floor.new(pos + (loaded_floors[1] as Floor).get_vals()[0], scene_id, prs_loc)
		loaded_floors_nodes[1] = new_scene
	else:
		printerr("Major floor error. Blame MMT and tell him he typecast wrong")

func reload_new_scene(pos: Vector2, scene_id: String, prs_loc: Vector2):
	# A lil crash failsafe
	if loaded_floors[1] is Floor:
		# Load the new scene
		var new_scene : Node2D = load_scene(pos, scene_id, prs_loc)
		
		# Unload any scene 2+ scenes ago
		if not loaded_floors[0] == null and loaded_floors_nodes[0] is Node2D:
			(loaded_floors_nodes[0] as Node2D).queue_free()
		
		# Push current scene to prev scene
		loaded_floors[0] = loaded_floors[1]
		loaded_floors_nodes[0] = loaded_floors_nodes[1]
		
		# Load new floor
		loaded_floors[1] = Floor.new(pos, scene_id, prs_loc)
		loaded_floors_nodes[1] = new_scene
		
		player.global_position = pos + prs_loc
	else:
		var new_scene : Node2D = load_scene(pos, scene_id, prs_loc)
		loaded_floors = [null, Floor.new(pos, scene_id, prs_loc), null]
		loaded_floors_nodes = [null, new_scene, null]
		player.global_position = pos + prs_loc

# Special variable setting for loading the tower's first floor
func load_first_stage(pos: Vector2, scene_id: String, prs_loc: Vector2):
	load_background(Vector2(0, 0))
	var new_scene : Node2D = load_scene(pos, scene_id, prs_loc)
	load_player(pos + prs_loc)
	loaded_floors = [null, Floor.new(pos, scene_id, prs_loc), null]
	loaded_floors_nodes = [null, new_scene, null]
	load_ui()

# Reloads the current and previous stages to default states
# Resets player HP
# Resets player to start of room
func restart_stage():
	player.heal()
	
	# Reload floors (This is honestly probably magic)
	var floor_0 : Floor = null
	if not loaded_floors[0] == null:
		floor_0 = loaded_floors[0]
	var floor_1 : Floor = loaded_floors[1]
	for f : Node2D in loaded_floors_nodes:
		if not f == null:
			f.queue_free()
	loaded_floors_nodes = [null, null, null]
	loaded_floors = [null, null, null]
	if not floor_0 == null:
		reload_new_scene(floor_0.get_vals()[0], floor_0.get_vals()[1], floor_0.get_vals()[2])
	reload_new_scene(floor_1.get_vals()[0], floor_1.get_vals()[1], floor_1.get_vals()[2])

func emit_health():
	health_update.emit()

func emit_spell():
	spell_update.emit()

# Internal class for storing loaded floor data
class Floor:
	var scene_id : String
	var pos : Vector2
	var player_respawn_location : Vector2
	
	func _init(pos_: Vector2, s_id: String, prs_loc : Vector2) -> void:
		self.scene_id = s_id
		self.pos = pos_
		self.player_respawn_location = prs_loc
	
	# Returns an array of [Pos, Scene_ID]
	func get_vals() -> Array:
		return [pos, scene_id, player_respawn_location]
	
	func _to_string() -> String:
		return "(" + str(pos) + ", " + str(scene_id) + ", " + str(player_respawn_location) + ")"
