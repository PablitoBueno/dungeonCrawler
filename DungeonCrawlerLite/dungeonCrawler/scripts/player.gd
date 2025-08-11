extends KinematicBody2D

var speed = 100
var health = 25
var damage = 2

onready var animated_sprite = $AnimatedSprite
var sword_scene = preload("res://scenes/sword.tscn")
var sword_instance = null

func _ready():
	sword_instance = sword_scene.instance()
	add_child(sword_instance)
	sword_instance.position = Vector2(20, 0)

func _physics_process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	
	move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		sword_instance.activate_attack()

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free() # Player desaparece


