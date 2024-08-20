class_name WizardBoss

extends Node2D

@onready var damage_zone: Area2D = $"Damage Zone"
@onready var explosion_png: ExplosionDotPng = $ExplosionPNG

@onready var explosion: AudioStreamPlayer2D = $"Damage Zone/Explosion"
@onready var vicotory: AudioStreamPlayer2D = $Vicotory
@onready var fwoosh: AudioStreamPlayer2D = $FWOOSH

@onready var idle: Node2D = $Idle
@onready var attack: Node2D = $Attack
@onready var defeat: Node2D = $Defeat

@onready var fire_gun: Marker2D = $"Fire Gun"

const FORB_BEEG = preload("res://scenes/game_objects/forb_beeg.tscn")

var health : int = 3

var attack_cooldown_max = 5.0
var atk_cd = 1000.0

var time_to_idle : float = 0.0
var idle_primed : bool = false

var dead : bool = false

var speed = 3

var shooty_bang_bang_timer : float = 0.0
var shooties_bang_banged : int = 3

var dead_timer : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not dead:
		atk_cd -= delta
		if atk_cd <= 0.5:
			set_visible_sprite(1)
		if atk_cd <= 0.0:
			atk_cd = attack_cooldown_max
			var rng = RandomNumberGenerator.new()
			if rng.randi_range(0, 1) == 1:
				attack_1()
			else:
				attack_2()
		
		if time_to_idle > 0.0:
			time_to_idle -= delta
		elif idle_primed:
			set_visible_sprite(0)
			idle_primed = false
		
		if shooty_bang_bang_timer > 0.0:
			shooty_bang_bang_timer -= delta
			if shooty_bang_bang_timer <= 1.0 and shooties_bang_banged <= 1:
				shooties_bang_banged += 1
				var forb_1 = FORB_BEEG.instantiate()
				forb_1.global_position = fire_gun.global_position
				forb_1.speed = speed
				forb_1.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).normalized()
				Game_Manager.game.add_child(forb_1)
				fwoosh.play()
			if shooty_bang_bang_timer <= 0.5 and shooties_bang_banged <= 2:
				shooties_bang_banged += 2
				var forb_1 = FORB_BEEG.instantiate()
				forb_1.global_position = fire_gun.global_position
				forb_1.speed = speed
				forb_1.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).normalized()
				Game_Manager.game.add_child(forb_1)
				fwoosh.play()
	
	else:
		dead_timer += delta
		# Death animation!
		var start: Vector2 = Vector2(-35, -186)
		var rng = RandomNumberGenerator.new()
		defeat.global_position = start + Vector2(rng.randf_range(-4.0, 4.0), rng.randf_range(-4.0, 4.0))
		defeat.global_position.y += dead_timer * 32.0
		
		if dead_timer <= 3.0:
			pass
		elif dead_timer <= 5.0:
			Game_Manager.player.freeze()
			var scale_var : float = 3.0 - (dead_timer - 3.0)
			Game_Manager.player.camera_2d.zoom = Vector2(scale_var, scale_var)
			if dead_timer >= 4.5:
				Game_Manager.ftw_ui.animation_player.play("fade_to_white")
		# 0.5 sec, fade to white
		elif dead_timer <= 6.0:
			pass
		# Load screen and move up player
		else:
			Game_Manager.load_final_cutscene()
			Game_Manager.player.queue_free()
			Game_Manager.ftw_ui.queue_free()
			Game_Manager.ui.queue_free()
			Game_Manager.unload_world()

func hurt_wizard():
	health -= 1
	if health <= 0:
		die()

func die():
	dead = true
	set_visible_sprite(2)
	Game_Manager.player.heal()
	(Game_Manager.game as Game).stop_music()
	vicotory.play()

func attack_1():
	time_to_idle = 1.75
	idle_primed = true
	shooty_bang_bang_timer = 1.5
	shooties_bang_banged = 1
	var forb_1 = FORB_BEEG.instantiate()
	forb_1.global_position = fire_gun.global_position
	forb_1.speed = speed
	forb_1.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).normalized()
	Game_Manager.game.add_child(forb_1)
	
	fwoosh.play()

func attack_2():
	time_to_idle = 0.5
	idle_primed = true
	var forb_1 = FORB_BEEG.instantiate()
	forb_1.global_position = fire_gun.global_position
	forb_1.speed = speed
	forb_1.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).normalized()
	Game_Manager.game.add_child(forb_1)
	
	var forb_2 = FORB_BEEG.instantiate()
	forb_2.global_position = fire_gun.global_position
	forb_2.speed = speed
	forb_2.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).rotated(PI / 16.0).normalized()
	Game_Manager.game.add_child(forb_2)
	
	var forb_3 = FORB_BEEG.instantiate()
	forb_3.global_position = fire_gun.global_position
	forb_3.speed = speed
	forb_3.direction = (Game_Manager.player.global_position + Vector2(0.0, -6.0) - fire_gun.global_position).rotated(-PI / 16.0).normalized()
	Game_Manager.game.add_child(forb_3)
	
	fwoosh.play()

func set_visible_sprite(val : int) -> void:
	idle.visible = (val == 0)
	attack.visible = (val == 1)
	defeat.visible = (val == 2)

func _on_damage_zone_body_entered(body: Node2D) -> void:
	if body is Hazard_Crate:
		# Blow up the crate and damage the Wizard
		body.queue_free()
		hurt_wizard()
		explosion.play()
		explosion_png.play_animation()
		pass
