extends IFieldInteractable

@export var default_launch_vel : float = 1000.0
@onready var collision_shape_character: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@onready var nine_patch_rect: NinePatchRect = $Sprite2D

# Variables about growing
var time_to_grow : float = 0.5
var growth_timer : float = 0.0

var default_size : Vector2
var default_pos : Vector2

func _ready():
	#collision_shape_character.disabled = true
	
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	
	# Defaults!
	default_size = Vector2(size[0], size[1])
	default_pos = Vector2(pos[0], pos[1])
	
	align_collider()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var launch_dir : Vector2 = (body.global_position - Vector2(0.0, 6.0)) - self.global_position
		launch_dir = launch_dir.normalized()
		
		var size_modifier : float = 1.0
		if grow_active > 0:
			size_modifier = 2.0
		
		launch_dir = launch_dir * default_launch_vel * size_modifier
		
		body.add_extra_velocity(launch_dir)
	pass # Replace with function body.

func align_collider():
	# Rescale the crate's components to match the visual.
	# First, align the collision box
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	var shape = collision_shape_2d.shape
	
	# Gen new door shape
	var circ = CircleShape2D.new()
	circ.radius = size[0] / 2.0
	collision_shape_2d.position = Vector2(size[0] / 2.0 + pos[0], size[1] / 2.0 + pos[1])
	collision_shape_2d.shape = circ

func _in_field_loop(_delta : float) -> void:
	if grow_active > 0:
		if growth_timer < time_to_grow:
			growth_timer += _delta
			nine_patch_rect.size = default_size * (((1.0 / time_to_grow) * growth_timer) + 1)
			if growth_timer >= time_to_grow:
				growth_timer = time_to_grow
				nine_patch_rect.size = default_size * 2
			align_collider()
	else:
		if growth_timer > 0:
			growth_timer -= _delta
			nine_patch_rect.size = default_size * (((1.0 / time_to_grow) * growth_timer) + 1)
			if growth_timer <= 0:
				nine_patch_rect.size = default_size
				growth_timer = 0
			align_collider()

func _out_field_loop(_delta : float) -> void:
	if growth_timer > 0:
		growth_timer -= _delta
		nine_patch_rect.size = default_size * (((1.0 / time_to_grow) * growth_timer) + 1)
		if growth_timer <= 0:
			nine_patch_rect.size = default_size
			growth_timer = 0
		align_collider()
