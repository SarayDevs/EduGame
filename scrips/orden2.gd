extends Node

signal orden_actualizada(porcentajes: Array, ingredientes: Array)

var pizza_instance
var porcentajes = []
var ingredientes = ["albahaca", "anchoa", "champiñon", "aceituna", "cebollin", "pimenton", "piña", "peperoni", "queso"]

func _ready():
	generarNuevaOrden()

func generarNuevaOrden():
	var numPorciones = randi() % 5 + 1  # Número aleatorio entre 2 y 8
	
	# Limpiar listas anteriores
	porcentajes.clear()
	
	# Generar porcentajes aleatorios únicos que sumen 100 con mínimo 10% cada uno
	var suma = 0
	var posibles_porcentajes = []
	
	for i in range(10, 101):
		posibles_porcentajes.append(i)
	
	for i in range(numPorciones - 1):
		posibles_porcentajes.shuffle()
		for porcentaje in posibles_porcentajes:
			var max_porcion = 100 - suma - (10 * (numPorciones - 1 - i))
			if porcentaje <= max_porcion:
				porcentajes.append(porcentaje)
				suma += porcentaje
				posibles_porcentajes.erase(porcentaje)
				break
	porcentajes.append(100 - suma)  # El último porcentaje completa el 100%
	
	# Generar ingredientes aleatorios únicos para cada porción
	var posibles_ingredientes = ingredientes.duplicate()
	var orden = {}
	var ingredientes_orden = []
	for i in range(numPorciones):
		posibles_ingredientes.shuffle()
		var ingrediente = posibles_ingredientes.pop_back()
		orden[i] = ingrediente
		ingredientes_orden.append(ingrediente)
	
	# Pasar la orden a la instancia de pizza (si es necesario)
	# pizza_instance.nuevaOrden(orden)
	
	# Mostrar la orden en el CanvasLayer
	$OrdenPizza.mostrarOrden(porcentajes, ingredientes_orden)
	# Emitir la señal con los porcentajes y los ingredientes
	emit_signal("orden_actualizada", porcentajes, ingredientes_orden)
