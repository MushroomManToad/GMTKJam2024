extends IFieldInteractable

@export var default_launch_vel : float = 1000.0
@export var launch_vel_big_mult : float = 2.0

@onready var collision_shape_character: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@onready var nine_patch_rect: NinePatchRect = $Sprite2D

const BALLOON_INFLATE_1 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate1.png")
const BALLOON_INFLATE_2 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate2.png")
const BALLOON_INFLATE_3 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate3.png")
const BALLOON_INFLATE_4 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate4.png")
const BALLOON_INFLATE_5 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate5.png")
const BALLOON_INFLATE_6 = preload("res://sprites/game_objects/balloon_inflate/balloon_inflate6.png")

const BALLOON = preload("res://sprites/game_objects/balloon.png")

# Variables about growing
var time_to_grow : float = 0.5
var growth_timer : float = 0.0

var default_size : Vector2
var default_pos : Vector2

var is_popped : bool = false
var pop_timer : float = 0.0
var unpop_timer : float = 2.0

func _ready():
	#collision_shape_character.disabled = true
	
	var size = nine_patch_rect.size
	var pos = nine_patch_rect.position
	
	# Defaults!
	default_size = Vector2(size[0], size[1])
	default_pos = Vector2(pos[0], pos[1])
	
	align_collider()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_popped:
		pop_timer += delta
		if pop_timer >= unpop_timer:
			nine_patch_rect.texture = BALLOON
			is_popped = false
			collision_shape_2d.set_deferred("disabled", false)
		elif pop_timer >= unpop_timer * 5.0 / 6.0:
			nine_patch_rect.texture = BALLOON_INFLATE_6
		elif pop_timer >= unpop_timer * 4.0 / 6.0:
			nine_patch_rect.texture = BALLOON_INFLATE_5
		elif pop_timer >= unpop_timer * 3.0 / 6.0:
			nine_patch_rect.texture = BALLOON_INFLATE_4
		elif pop_timer >= unpop_timer * 2.0 / 6.0:
			nine_patch_rect.texture = BALLOON_INFLATE_3
		elif pop_timer >= unpop_timer * 1.0 / 6.0:
			nine_patch_rect.texture = BALLOON_INFLATE_2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var launch_dir : Vector2 = (body.global_position - Vector2(0.0, 6.0)) - self.global_position
		launch_dir = launch_dir.normalized()
		
		var size_modifier : float = 1.0
		if grow_active > 0:
			size_modifier = launch_vel_big_mult
		
		launch_dir = launch_dir * default_launch_vel * size_modifier
		
		body.add_extra_velocity(launch_dir)
		pop_balloon()
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

func pop_balloon():
	collision_shape_2d.set_deferred("disabled", true)
	is_popped = true
	pop_timer = 0.0
	nine_patch_rect.texture = BALLOON_INFLATE_1
