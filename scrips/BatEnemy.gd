extends CharacterBody2D

const FLY_SPEED = 120
const GRAVITY = 98
var hit = false
var dead = 0
@onready var auch=$Auch

func _ready():
	velocity.y = -FLY_SPEED
	$BatAnimatedSprite2D.play("Volar")

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	morir()
	
	if is_on_ceiling():
		velocity.y = FLY_SPEED
	elif is_on_floor():
		velocity.y = -FLY_SPEED
		
	if velocity.y < 0:
		$BatAnimatedSprite2D.flip_h = false
	elif velocity.y > 0:
		$BatAnimatedSprite2D.flip_h = true
	
	move_and_slide()
	
func morir():
	if hit and dead == 0:
		dead = 1
		set_physics_process(false)
		$BatAnimatedSprite2D.play("Die")
		$"daño/CollisionShape2D".disabled = true
		$CollisionShape2D.disabled = true
		await($BatAnimatedSprite2D.animation_finished)
		$BatAnimatedSprite2D.visible = false  # Oculta el Sprite
		queue_free()  # Elimina el nodo después de la animación


func _on_daño_body_entered(body):
	if body.is_in_group("player"):
		$"..".lose_corazon()
		auch.play()
	pass # Replace with function body.
