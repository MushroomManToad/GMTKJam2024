extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var button_deselect: Sprite2D = $Button_Deselect
@onready var button_hovered: Sprite2D = $Button_Hovered
@onready var button_select: Sprite2D = $Button_Select
@onready var label: Label = $Label

@export var scene_id : String
@export var pos : Vector2

var hovered: bool = false
var primed: bool = false

func _ready():
	label.text = scene_id

func _process(delta: float) -> void:
	if Input.is_action_pressed("LeftClick") and hovered:
		set_visible_layer(2)
		primed = true
	if not Input.is_action_pressed("LeftClick") and hovered:
		set_visible_layer(1)
		if primed:
			Game_Manager.load_scene(pos, scene_id)
			primed = false

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	if Input.is_action_pressed("LeftClick"):
		set_visible_layer(2)
	else:
		set_visible_layer(1)

func _on_area_2d_mouse_exited() -> void:
	set_visible_layer(0)
	hovered = false
	primed = false

func set_visible_layer(layer : int) -> void:
	button_deselect.visible = (layer == 0)
	button_hovered.visible = (layer == 1)
	button_select.visible = (layer == 2)
