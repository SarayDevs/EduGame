
extends CharacterBody2D
const BASE_SPEED = 100.0
var SPEED = BASE_SPEED
const JUMP_VELOCITY = -800
const GRAVITY = 40

signal ScoreUP
signal PlayerDied
signal MaxItems

@onready var rata_scene = preload("res://Escenas/RataEnemy.tscn")
@onready var Anim = $CapibaraAnimatedSprite2D
@onready var spr = $Sprite2D
@onready var sprS = $Sprite2D2
@onready var salto = $Saltar
@onready var ataque=$Atacar
@onready var recolectar=$Recolectar2
@onready var auch=$Auch


func _ready():
	pass

func _physics_process(_delta):
	# Ajusta la velocidad del jugador basado en la dificultad
	get_tree().root.get_node("res://Escenas/reproductor.tscn")

	if not is_on_floor():
		Anim.play()
		velocity.y += GRAVITY
		

	if Input.is_action_just_pressed("Arriba") and is_on_floor():
		$CapibaraAnimatedSprite2D.visible = false
		$Sprite2D2.visible = true
		$Sprite2D2/AnimationPlayer.play("saltar")
		velocity.y = JUMP_VELOCITY
		salto.play()
	else: 
		if Input.is_action_just_released("Arriba"):
			velocity.y += 400
	
	var direction = Input.get_axis("Izquierda", "Derecha")
	if direction:
		velocity.x = direction * SPEED
		Anim.play("caminar")
	
	if direction < 0:
		$Ata/CollisionShape2D2.position.x = -18.5
		Anim.flip_h = true
		spr.flip_h = true
	elif direction > 0:
		$Ata/CollisionShape2D2.position.x = 18.5
		Anim.flip_h = false
		spr.flip_h = false
	else:
		Anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction < 0:
		$Ata/CollisionShape2D2.position.x = -18.5
		Anim.flip_h = true
		sprS.flip_h = true
	elif direction > 0:
		$Ata/CollisionShape2D2.position.x = 18.5
		Anim.flip_h = false
		sprS.flip_h = false
	
	move_and_slide()

func subirScore():
	emit_signal("ScoreUP")
	
func morirse():
	$CapibaraAnimatedSprite2D.play("Die")
	emit_signal("PlayerDied")
	
func victoria():
	$CapibaraAnimatedSprite2D.play("WIN")
	
func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"saltar":
			$CapibaraAnimatedSprite2D.visible = true
			$Sprite2D2.visible = false


func _on_mundo_2_dificultad_cambiada(new_dificultad):
	SPEED = BASE_SPEED + new_dificultad * 50
