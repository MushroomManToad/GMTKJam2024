class_name Crate

extends IPushableObject

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var nine_patch_rect: NinePatchRect = $Crate

var center : Vector2
var grown : bool = false

var default_size : Vector2
var default_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	var shape = collision_shape_2d.shape
	
	# Defaults!
	default_size = Vector2(size[0], size[1])
	default_pos = Vector2(pos[0], pos[1])
	
	align_collider()

func align_collider():
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

func _get_top():
	return global_position[1] + nine_patch_rect.position[1]

func _get_bottom():
	var c_1 = get_size()[1] + nine_patch_rect.position[1]
	return global_position[1] + c_1

func get_center() -> Vector2:
	var pos : Vector2 = nine_patch_rect.position
	var size : Vector2 = get_size()
	return Vector2(size[0] / 2.0 + pos[0], size[1] / 2.0 + pos[1])

func get_size() -> Vector2:
	return nine_patch_rect.size

func _in_field_loop(delta : float) -> void:
	if grow_active > 0:
		if not grown:
			nine_patch_rect.size = default_size * 2
			align_collider()
			grown = true
	else:
		if grown:
			nine_patch_rect.size = default_size
			align_collider()
			grown = false

func _out_field_loop(delta : float) -> void:
	print(grown)
	if grown:
		nine_patch_rect.size = default_size
		align_collider()
		grown = false
