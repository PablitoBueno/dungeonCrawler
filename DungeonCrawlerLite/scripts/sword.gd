extends Area2D

var damage = 2
var attack_duration = 0.3
var attack_timer = 0.0

var attack_distance = 70
var attack_speed = 300

# Parâmetros da órbita
var orbit_radius = 40
var orbit_speed = 20.0

# Variáveis de ataque
var is_attacking = false
var is_returning = false
var attack_start_position = Vector2.ZERO
var attack_target_position = Vector2.ZERO

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(true)

func _process(delta):
	if is_attacking:
		handle_attack(delta)
	else:
		update_orbit_position()

func update_orbit_position():
	# Calcular direção do mouse em relação ao personagem
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_parent().global_position
	var direction = (mouse_pos - player_pos).normalized()
	
	# Posicionar a espada na direção do mouse, na distância orbital
	position = direction * orbit_radius
	
	# Rotacionar a espada para apontar para o mouse
	rotation = direction.angle()

func activate_attack() -> bool:
	if is_attacking:
		return false

	is_attacking = true
	is_returning = false
	$CollisionShape2D.set_deferred("disabled", false)
	attack_timer = attack_duration

	# Guardar posições para o ataque
	attack_start_position = position
	attack_target_position = position + (position.normalized() * attack_distance)

	return true

func handle_attack(delta):
	attack_timer -= delta
	
	if not is_returning:
		# Mover para frente na direção do ataque
		position = position.move_toward(attack_target_position, attack_speed * delta)
		
		# Verificar se chegou ao ponto máximo
		if position.distance_to(attack_target_position) < 1:
			is_returning = true
	else:
		# Calcular nova posição orbital baseada no mouse
		update_orbit_position()
		var return_position = position
		
		# Voltar para posição orbital
		position = position.move_toward(return_position, attack_speed * delta)
		
		# Verificar se voltou à órbita
		if position.distance_to(return_position) < 1:
			deactivate_attack()
	
	# Desativar se o tempo acabar
	if attack_timer <= 0:
		deactivate_attack()

func deactivate_attack():
	$CollisionShape2D.set_deferred("disabled", true)
	is_attacking = false
	is_returning = false
	update_orbit_position()  # Garantir que está na posição correta

func _on_Sword_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		deactivate_attack()
