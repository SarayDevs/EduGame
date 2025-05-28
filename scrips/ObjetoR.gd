extends Area2D

var es_fruta = false
var objetos = [
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes1.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes5.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes9.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes14.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes19.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes20.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes23.png"),
	preload("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/pepperoni.png"),
]
var bomba = preload("res://Kings and Pigs/Sprites/09-Bomb/Bomb Off.png")

var Speed: float = 100.0  # Velocidad inicial

func _ready():
	# Decide al azar si es fruta o no
	if randf() > .2:  # Ajusta la probabilidad según necesites
		es_fruta = true

	# Si no es fruta, es una bomba
	if !es_fruta:
		$Sprite.texture = bomba
	else:
		# Elige una textura de fruta al azar
		$Sprite.texture = objetos[randi() % objetos.size()]

func _on_body_entered(body):
	if body.is_in_group("player"):
		if es_fruta:
			body.subirScore()
		else:
			body.morirse()
		queue_free()
	
func _process(delta):
	# Usa delta para mover el objeto hacia abajo
	position.y += Speed * delta
