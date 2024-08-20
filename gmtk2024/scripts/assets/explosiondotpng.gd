class_name ExplosionDotPng

extends AnimatedSprite2D

var countdown : float = 0.0

func _process(delta: float) -> void:
	if countdown >= 0:
		countdown -= delta
	elif visible:
		visible = false
		stop()

func play_animation():
	visible = true
	play()
	countdown = 0.45
