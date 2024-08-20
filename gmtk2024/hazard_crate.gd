class_name Hazard_Crate

extends IPushableObject

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var nine_patch_rect: NinePatchRect = $Crate
@onready var hazard_symbol: Sprite2D = $Sprite2D

var center : Vector2

# Variables about growing
var time_to_grow : float = 0.5
var growth_timer : float = 0.5

var default_size : Vector2
var default_pos : Vector2

var amount_to_scale : Vector2 = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	
	# Defaults!
	default_size = Vector2(size[0], size[1])
	default_pos = Vector2(pos[0], pos[1])
	
	align_collider()

func align_collider():
	# Rescale the crate's components to match the visual.
	# First, align the collision box
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	
	# Gen new door shape
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(size[0] / 2.0, size[1] / 2.0)
	collision_shape_2d.position = Vector2(size[0] / 2.0 + pos[0], size[1] / 2.0 + pos[1])
	collision_shape_2d.set_deferred("shape", rect)
	
	hazard_symbol.position = Vector2(size[0] / 2.0 - 16.0, size[1] / 2.0 - 16.0)

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

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if growth_timer < time_to_grow:
		growth_timer += delta
		nine_patch_rect.size += amount_to_scale * (delta / time_to_grow)
		if growth_timer >= time_to_grow:
			growth_timer = time_to_grow
			nine_patch_rect.size = default_size * get_scale_target_size_scalar()
		align_collider()

func _on_field_update():
	# Get relative scales at present and at target.
	var current_size : Vector2 = nine_patch_rect.size
	var target_size : Vector2 = default_size * get_scale_target_size_scalar()
	# Don't do anything if scaling doesn't need to change after the field updates
	amount_to_scale = target_size - current_size
	
	# Reset scaling timer
	growth_timer = 0

func get_scale_target_size_scalar() -> Vector2:
	var size = Vector2(1.0, 1.0)
	# Cases
	if grow_active > 0:
		size = Vector2(size[0] * 2.0, size[1] * 2.0)
	if stretch_active > 0:
		size = Vector2(size[0] * 6.0, size[1])
	if rotate_active > 0:
		size = Vector2(size[0], size[1]* 5.0)
	return size
