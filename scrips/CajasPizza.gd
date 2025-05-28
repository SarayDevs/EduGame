extends Area2D

var Caja1
var Caja2
var isCorrectPizza = null



func _ready():
	# Obtener referencias a las cajas en la escena
	Caja1 = get_node("/root/Nivel2/CajaPropia")
	Caja2 = get_node("/root/Nivel2/CajaImpropia")
	
	# Conectar la señal de la pizza a una función en esta caja
	#var _pizza = get_node("res://Escenas/Pizzas.tscn")
	# Ajusta esta ruta según la estructura de tu escena

func _on_pizzas_pizza_colocada(pizza: Area2D, es_propia: bool):
# Evaluar si la caja correcta recibe la pizza correcta
	if (Caja1.get_overlapping_areas().has(pizza) and es_propia) or (Caja2.get_overlapping_areas().has(pizza) and !es_propia):
		isCorrectPizza = true
	else:
		isCorrectPizza = false
		
	drag_end()



func drag_end():
	print("Procesando resultado...")
	if isCorrectPizza:
		print("Suma puntos")
		# Asegúrate de que "subirScore" es una función válida en el nodo padre
		$"..".subirScore()
	elif !isCorrectPizza: 
		print("Pierde una estrella")
		# Asegúrate de que "lose_star" es una función válida en el nodo padre
		$"..".lose_star()
		
	isCorrectPizza = null  # Reiniciamos la variable para la próxima interacción
