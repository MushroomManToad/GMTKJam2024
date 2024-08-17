extends Area2D

# Choose one of these to be the field type for initialization
@export var type_grow : bool
@export var type_stretch : bool
@export var type_rotate : bool

# Sprite holders
@onready var grow_sprite: AnimatedSprite2D = $GrowSprite
@onready var stretch_sprite: AnimatedSprite2D = $StretchSprite
@onready var rotate_sprite: AnimatedSprite2D = $RotateSprite

func _ready():
	# Set active sprite(s) by field
	grow_sprite.visible = type_grow
	stretch_sprite.visible = type_stretch
	rotate_sprite.visible = type_rotate
