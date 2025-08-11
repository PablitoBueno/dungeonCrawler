extends Area2D

var damage = 2
var attack_duration = 0.3
var attack_timer = 0.0

var attack_distance = 40
var attack_speed = 300
var start_position = Vector2.ZERO
var target_position = Vector2.ZERO
var moving_forward = false
var moving_back = false

func _ready():
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

func activate_attack():
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	attack_timer = attack_duration
	
	start_position = position
	# Estocada para cima (norte), Y negativo
	target_position = start_position + Vector2(0, -attack_distance)
	moving_forward = true
	moving_back = false

func _process(delta):
	attack_timer -= delta
	
	if moving_forward:
		position = position.move_toward(target_position, attack_speed * delta)
		if position.distance_to(target_position) < 1:
			moving_forward = false
			moving_back = true
	
	elif moving_back:
		position = position.move_toward(start_position, attack_speed * delta)
		if position.distance_to(start_position) < 1:
			moving_back = false
	
	if attack_timer <= 0 and not moving_forward and not moving_back:
		deactivate_attack()

func deactivate_attack():
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	position = start_position

func _on_Sword_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		deactivate_attack()
