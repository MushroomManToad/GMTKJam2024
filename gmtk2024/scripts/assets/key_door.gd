class_name KeyDoor

extends ITogglable

var is_closed : bool = true

var power : int = 0

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
	collision_shape_2d.disabled = true

func close_door():
	is_closed = true

func _on_toggle():
	if is_closed:
		open_door()
	else:
		close_door()

# For handling number of buttons holding door open
func add_power(val : int):
	power = power + val
	if is_closed and val > 0:
		open_door()
	elif not is_closed and val <= 0:
		val = 0
		close_door()
