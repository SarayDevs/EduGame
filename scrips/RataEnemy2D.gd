extends CharacterBody2D

const SPEED = 50
const Gravedad = 98
const DISTANCIA_LIMITE = 100
var dead = 1
var hit = false
var distancia_recorrida = 0
@onready var player_scene = preload("res://Escenas/RataEnemy.tscn")
@onready var auch=$Auch

func _ready():
	velocity.x = -SPEED
	$RataAnimatedSprite2D.play("Move")
	
	
func _physics_process(delta):
	velocity.y += Gravedad
	morir()
	
	if is_on_wall():
		if !$RataAnimatedSprite2D.flip_h:
			velocity.x = SPEED
		else:
			velocity.x = -SPEED
			
	if velocity.x < 0:
		$RataAnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$RataAnimatedSprite2D.flip_h = true
		
	distancia_recorrida += abs(velocity.x * delta)
	
	if distancia_recorrida >= DISTANCIA_LIMITE:
		cambiar_direccion()
		distancia_recorrida = 0 
	move_and_slide()
	
func cambiar_direccion():
	if !$RataAnimatedSprite2D.flip_h:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
		
	$RataAnimatedSprite2D.flip_h = !$RataAnimatedSprite2D.flip_h
		
func morir():
	if hit and dead > 0:
		set_physics_process(false)
		$RataAnimatedSprite2D.play("Die")
		$"RataArea2D/DañoCollisionShape2D".disabled = true
		$RataCollisionShape2D.disabled = true
		await($RataAnimatedSprite2D.animation_finished)
		$RataAnimatedSprite2D.visible = false  # Oculta el Sprite
		queue_free()  # Elimina el nodo después de la animación
		

func _on_rata_area_2d_body_entered(body):
	if body.is_in_group("player"):
		auch.play()
		$"..".lose_corazon()
	else:
		$RataAnimatedSprite2D.play("Move")
	pass # Replace with function body.
