extends Area2D

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


func _on_body_entered(body: Node2D) -> void:
	if body is IFieldInteractable:
		(body as IFieldInteractable).set_in_field(true)
		colliding_bodies.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body is IFieldInteractable:
		(body as IFieldInteractable).set_in_field(false)
		colliding_bodies.erase(body)


func dump_bodies() -> void:
	for body in colliding_bodies:
		if body is IFieldInteractable:
			(body as IFieldInteractable).set_in_field(false)
	colliding_bodies.clear()
