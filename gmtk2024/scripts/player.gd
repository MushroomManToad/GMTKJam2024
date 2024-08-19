class_name Player

extends CharacterBody2D

@export var SPEED : float
@export var JUMP_VELOCITY : float

var vent_count : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

var camera_zoom : bool = false

# This represents the player's inertia.
@export var push_force = 80.0

@export var extra_velocity : Vector2 = Vector2(0, 0)

@onready var spells_handler : SpellsHandler = SpellsHandler.new(self)

var oyv : bool = true

func _process(_delta: float) -> void:
	if not camera_zoom and Input.is_action_pressed("Zoom"):
		camera_zoom_out()
	if camera_zoom and not Input.is_action_pressed("Zoom"):
		camera_zoom_reset()

func _physics_process(delta):
	spells_handler.physics_loop()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if oyv:
		velocity.y = 0
		oyv = false

	# Handle jump.
	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("Left", "Right")
	
	if Input.is_action_just_pressed("Up"):
		velocity.y = JUMP_VELOCITY
	
	if vent_count > 0:
		velocity.y = JUMP_VELOCITY / 2.0
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Apply movement
	if direction:
		if abs(velocity.x) <= SPEED:
			velocity.x = direction * SPEED
		else:
			velocity.x = velocity.x + direction * SPEED * 0.05
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var is_pushing = false

	velocity += extra_velocity
	
	extra_velocity = Vector2(0, 0)
	
	move_and_slide()
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is IPushableObject:
			var c_ = c.get_collider() as IPushableObject
			var ypos = self.position[1] + 1.0
			if ypos > c_._get_top() and ypos < c_._get_bottom() + 6.0:
				is_pushing = true
				if self.position[0] < c_.position.x:
					c_.update_velocity(Vector2(c_.SPEED, 0))
				else:
					c_.update_velocity(Vector2(-c_.SPEED, 0))
			if ypos > c_._get_bottom() + 8.0:
				if self.position[0] < c_.position.x:
					c_.update_velocity(Vector2(c_.SPEED, -4.0))
				else:
					c_.update_velocity(Vector2(-c_.SPEED, -4.0))
	# Play Animations
	if is_pushing:
		animated_sprite.play("push")
	else:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			if velocity.y < 0.0:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("fall")

func camera_zoom_out() -> void:
	camera_zoom = true
	camera_2d.zoom = Vector2(1.0, 1.0)
	pass

func camera_zoom_reset() -> void:
	camera_zoom = false
	camera_2d.zoom = Vector2(3.0, 3.0)
	pass

func add_extra_velocity(input_vel : Vector2):
	extra_velocity += input_vel

func override_y_velocity():
	oyv = true

class SpellsHandler:
	var active_grow_field : Node2D = null
	var active_stretch_field : Node2D = null
	var active_rotate_field : Node2D = null
	
	var grow_unlocked : bool = false
	var stretch_unlocked : bool = false
	var rotate_unlocked : bool = false
	
	var selected_spell : String = "none"
	
	var player : Player
	
	const SPELL_CASTER = preload("res://scenes/player/spell_caster.tscn")
	
	func _init(player_ : Player) -> void:
		self.player = player_
	
	func physics_loop():
		if Input.is_action_just_pressed("LeftClick"):
			if not selected_spell == "none":
				cast()
	
	func cast():
		var offset = 0.0
		if not player.animated_sprite.flip_h:
			offset = 5.0
		else:
			offset = -5.0
		
		var source : Vector2 = player.global_position + Vector2(offset, -6.0)
		var mousePosInWorld : Vector2 = player.get_global_mouse_position()
		
		var direction = (mousePosInWorld - source).normalized()
		
		var spell_instance : SpellCaster = SPELL_CASTER.instantiate()

		spell_instance.global_position = source
		spell_instance.set_direction(direction)
		spell_instance.set_spell(selected_spell)
		spell_instance.set_destination(mousePosInWorld)
		spell_instance.player = player
		Game_Manager.game.add_child(spell_instance)
