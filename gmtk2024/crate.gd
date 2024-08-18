class_name Crate

extends Node

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var nine_patch_rect: NinePatchRect = $Crate
@onready var crate_center_sprite: Sprite2D = $icons
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#With apologies to MushroomManToad. Sorry. I'm a terrible artist and an even worse coder. -p8
	
	# Rescale the crate's components to match the visual.
	# First, align the collision box
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	var shape = collision_shape_2d.shape
	
	# Gen new door shape
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(size[0] / 2.0, size[1] / 2.0)
	collision_shape_2d.position = Vector2(size[0] / 2.0 + pos[0], size[1] / 2.0 + pos[1])
	collision_shape_2d.shape = rect
	
	# Now, update the center sprite
	crate_center_sprite.position = Vector2(size[0] / 2.0, size[1] / 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
