extends Area2D

var initial_position: Vector2
var mousein = false
var cortes: int = 0  # Cantidad de porciones cortadas
var denominador_fraccion: int
var fraccion_numerador: int 
signal cortar_pizza()
signal cortar_excedido()
signal corte_menor()

@onready var cortar = $"../Cortar"

func _ready():
	# Guardar la posición inicial del sprite
	initial_position = position
	_on_plato_reiniciarfracciones()


func _process(_delta):
	if mousein and Input.is_action_pressed("Click"):
		position = get_viewport().get_mouse_position()

	# Si mousein es falso, devolver el sprite a su posición inicial
	if !mousein:
		position = initial_position
	

func _on_mouse_entered():
	mousein = true

func _on_mouse_exited():
	mousein = false

# Incrementar el denominador cada vez que se corta la pizza

func _on_area_entered(area):
	if area.is_in_group("mitad") or is_in_group("porciones"):
		_on_cortar_pizza()
		cortar.play()
		print("denominador")  # Replace with function body.

func _on_cortar_excedido():
	_on_plato_reiniciarfracciones()
	

func _on_cortar_pizza():
	if cortes <= 8: 
		print("un corte")
		cortes += 2
		print(cortes)
		


func _on_plato_reiniciarfracciones():
	print ("espera")
	denominador_fraccion = randi_range(1, 4) * 2  # Generar un número aleatorio par entre 0 y 8
	cortes = 0
	fraccion_numerador = randi_range(1, denominador_fraccion)  # Generar un numerador aleatorio menor o igual al denominador
	$"../Fraccion/denominador".text = str(denominador_fraccion)
	$"../Fraccion/numerador".text = str(fraccion_numerador)



func _on_timbre_2d_evaluar_timbre():
	if cortes > denominador_fraccion:
		emit_signal("cortar_excedido")
	if cortes < denominador_fraccion:
		emit_signal("corte_menor")
