extends Area2D

@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Choose one of these to be the field type for initialization
@export var type_grow : bool
@export var type_stretch : bool
@export var type_rotate : bool

# Sprite holders
@onready var grow_sprite: AnimatedSprite2D = $GrowSprite
@onready var stretch_sprite: AnimatedSprite2D = $StretchSprite
@onready var rotate_sprite: AnimatedSprite2D = $RotateSprite

var colliding_bodies : Array

func _ready():
	# Set active sprite(s) by field
	grow_sprite.visible = type_grow
	stretch_sprite.visible = type_stretch
	rotate_sprite.visible = type_rotate
	align_collider()


func _on_body_entered(body: Node2D) -> void:
	if body is IFieldInteractable:
		(body as IFieldInteractable).set_in_field(true)
		if type_grow:
			body.add_field("grow")
		if type_stretch:
			body.add_field("stretch")
		if type_rotate:
			body.add_field("rotate")
		colliding_bodies.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body is IFieldInteractable:
		(body as IFieldInteractable).set_in_field(false)
		if type_grow:
			body.remove_field("grow")
		if type_stretch:
			body.remove_field("stretch")
		if type_rotate:
			body.remove_field("rotate")
		colliding_bodies.erase(body)


func dump_bodies() -> void:
	for body in colliding_bodies:
		if body is IFieldInteractable:
			(body as IFieldInteractable).set_in_field(false)
			if type_grow:
				body.remove_field("grow")
			if type_stretch:
				body.remove_field("stretch")
			if type_rotate:
				body.remove_field("rotate")
	colliding_bodies.clear()

func align_collider():
	# Rescale the crate's components to match the visual.
	# First, align the collision box
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	var shape = collision_shape_2d.shape
	
	# Gen new door shape
	var rect = RectangleShape2D.new()
	rect.extents = Vector2((size[0] / 2.0) - 2.0, (size[1] / 2.0) - 2.0)
	collision_shape_2d.position = Vector2(size[0] / 2.0 + pos[0], size[1] / 2.0 + pos[1])
	collision_shape_2d.shape = rect
