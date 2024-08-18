class_name KeyDoor

extends ITogglable

var is_closed : bool = true

@export var required_power : int = 1

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var door_center_sprite: Sprite2D = $NinePatchRect/DoorCenter

func _ready():
	# Rescale the door's components to match the visual.
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
	door_center_sprite.position = Vector2(size[0] / 2.0, size[1] / 2.0)

func open_door():
	is_closed = false
	collision_shape_2d.set_deferred("disabled", true)

func close_door():
	is_closed = true
	collision_shape_2d.set_deferred("disabled", false)

func _on_toggle():
	if is_closed:
		open_door()
		nine_patch_rect.visible = false
	else:
		close_door()

func _add_power(val : int):
	super._add_power(val)
	if is_closed and power >= required_power:
		open_door()
	elif not is_closed and power < required_power:
		close_door()
