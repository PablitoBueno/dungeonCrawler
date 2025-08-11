extends Area2D

var damage = 2
var attack_duration = 0.2
var attack_timer = 0.0

func _ready():
	set_process(false) # Desativa o processamento por padrão
	$CollisionShape2D.set_deferred("disabled", true) # Desativa a colisão por padrão

func activate_attack():
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	attack_timer = attack_duration

func _process(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		deactivate_attack()

func deactivate_attack():
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

func _on_Sword_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		deactivate_attack() # Garante que a espada não cause dano múltiplas vezes no mesmo ataque


