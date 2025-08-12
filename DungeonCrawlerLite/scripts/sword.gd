extends Area2D

var damage = 2
var attack_duration = 0.3
var attack_timer = 0.0

var attack_distance = 40
var attack_speed = 300

# Posição de repouso fixa (relativa ao player)
const REST_POSITION = Vector2(42.043, 30.14)

var rest_position = REST_POSITION
var start_position = Vector2.ZERO
var target_position = Vector2.ZERO

var moving_forward = false
var moving_back = false
var is_attacking = false

func _ready():
	# força a posição de repouso fixa
	rest_position = REST_POSITION
	position = rest_position

	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

# Tenta ativar o ataque. Retorna true se começou, false se já estiver atacando.
func activate_attack() -> bool:
	if is_attacking:
		return false

	is_attacking = true
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	attack_timer = attack_duration

	# Usa sempre a posição de repouso fixa como origem
	start_position = rest_position
	target_position = start_position + Vector2(0, -attack_distance) # norte = Y negativo
	position = start_position
	moving_forward = true
	moving_back = false

	return true

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

	# só desativa quando o timer acabou e a espada já voltou
	if attack_timer <= 0 and not moving_forward and not moving_back:
		deactivate_attack()

func deactivate_attack():
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	position = rest_position
	is_attacking = false

func _on_Sword_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		# opcional: terminar o ataque ao acertar
		deactivate_attack()
