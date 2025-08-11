extends KinematicBody2D

var health = 10
var speed = 50
var damage = 2
var target = null # O jogador
var attack_range = 30
var attack_cooldown = 1.0
var attack_timer = 0.0

onready var animated_sprite = $AnimatedSprite

func _ready():
	target = get_parent().get_node("Player")
	attack_timer = attack_cooldown

func _physics_process(delta):
	attack_timer -= delta
	
	if target and is_instance_valid(target):
		var distance = position.distance_to(target.position)
		
		if distance > attack_range:
			# Mover em direção ao jogador
			var direction = (target.position - position).normalized()
			var velocity = direction * speed
			move_and_slide(velocity)
			animated_sprite.play("default")
		else:
			animated_sprite.stop()
			if attack_timer <= 0:
				# Atacar o jogador
				attack()
				attack_timer = attack_cooldown

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free() # Rei Slime morre

func attack():
	if target and is_instance_valid(target):
		var distance = position.distance_to(target.position)
		if distance <= attack_range:
			target.take_damage(damage)


