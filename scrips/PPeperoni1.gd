extends Area2D

var initial_position2: Vector2
var mousedentro = false
var pizzas = []
var current_pizza_index = -1
# Variables de control
var objeto_sujeto = false
var objeto_soltado = true
@onready var sujetar=$Agarrar
@onready var soltar=$Soltar

signal pizza_colocada(pizza: Area2D, es_propia: bool)

func _ready():
	initial_position2 = position
	load_pizzas()
	random_pizza()

func _process(_delta):
	if mousedentro and Input.is_action_pressed("Click"):
		if not objeto_sujeto:
			sujetar.play()
			objeto_sujeto = true
			objeto_soltado = false
		position = get_viewport().get_mouse_position()
	elif mousedentro and Input.is_action_just_released("Click"):
		if not objeto_soltado:
			soltar.play()
			objeto_sujeto = false
			objeto_soltado = true


func _on_mouse_exited():
	mousedentro = false

func _on_mouse_entered():
	mousedentro = true

func _on_area_entered(area):
	if area.is_in_group("cajas"):
		print("Es una caja")
		emit_signal("pizza_colocada", self, pizzas[current_pizza_index]["es_propia"])
		await get_tree().create_timer(1.0).timeout
		_on_timer_timeout()

func _on_timer_timeout():
	pizzas[current_pizza_index]["sprite"].visible = false
	random_pizza()
	position = initial_position2

var pizzas_data = [
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/Orden34.png", "es_propia": true},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/Orden53.png", "es_propia": false},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden76.png", "es_propia": false},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden45.png", "es_propia": true},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden22.png", "es_propia": true},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden24.png", "es_propia": true},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden68.png", "es_propia": true},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden168.png", "es_propia": false},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden116.png", "es_propia": false},
	{"sprite": "res://MARIA JOSÉ ASSETS/2ACTIVIDAD/ordenes/orden52.png", "es_propia": false}
	
	

	
	
]

func load_pizzas():
	for pizza_data in pizzas_data:
		var sprite = Sprite2D.new()
		sprite.texture = load(pizza_data["sprite"])
		sprite.visible = false
		add_child(sprite)
		pizzas.append({"sprite": sprite, "es_propia": pizza_data["es_propia"]})

func random_pizza():
	if current_pizza_index != -1:
		pizzas[current_pizza_index]["sprite"].visible = false
	
	current_pizza_index = randi() % pizzas.size()
	var pizza = pizzas[current_pizza_index]
	pizza["sprite"].visible = true
