extends Node2D

# Señal para emitir cuando las divisiones son actualizadas
signal divisiones_actualizadas(divisions)

# Datos de la orden
var orden_actual = {
	"ingredientes": [],  # Lista de ingredientes esperados para cada porción
	"porcentajes": []    # Lista de porcentajes correspondientes a cada porción
}

# Lista de ingredientes colocados por el jugador
var ingredientes_colocados = []

# Divisiones de la pizza (ángulos en grados)
var pizza_divisions = []

# Lista para almacenar las divisiones y etiquetas
var divisions = []
var ingredient_textures = []
var porcentajes1 = []
var labels = []

func _ready():
	# Buscar el nodo orden_pizza en la escena y conectar señales
	var orden_pizza_node = get_node("../../nodo_control")
	if orden_pizza_node:
		print("Nodo encontrado")
		#orden_pizza_node.connect("orden_actualizada", self, "_on_nodo_control_orden_actualizada")
	else:
		print("Error: Nodo de orden de pizza no encontrado.")
	
func _on_nodo_control_orden_actualizada(porcentajes, ingredientes_orden):
	# Actualiza los porcentajes y los ingredientes de la orden
	orden_actual["ingredientes"] = ingredientes_orden
	orden_actual["porcentajes"] = porcentajes
	porcentajes1 = porcentajes
	create_divisions(porcentajes, ingredientes_orden)
	update_labels()

func _on_divisiones_actualizadas(divisions):
	pizza_divisions = divisions

func create_divisions(porcentajes, ingredientes_orden):
	divisions.clear()
	ingredient_textures.clear()
	
	# Eliminar etiquetas anteriores
	for label in labels:
		label.queue_free()
	labels.clear()

	# Verificar si algún porcentaje es 100
	for porcentaje in porcentajes:
		if porcentaje == 100:
			queue_redraw()  # Redibujar sin líneas
			return
	
	var total_angle = 0
	var pizza_radius = 160  # Radio de la pizza, ajusta según tu sprite

	for i in range(porcentajes.size()):
		var porcentaje = porcentajes[i]
		var angle = porcentaje * 3.6  # Convertir porcentaje a grados (360 grados en un círculo)
		total_angle += angle
		divisions.append(total_angle)
		#ingredient_textures.append(load("res://MARIA JOSÉ ASSETS/3ACTIVIDAD/ingredientes/" + ingredientes_orden[i] + ".png"))

		# Crear y añadir etiquetas
		var label = Label.new()
		label.text = percentage_to_fraction(porcentaje)  # Usar fracción en lugar de porcentaje
		label.set_custom_minimum_size(Vector2(100, 100))  # Tamaño de la etiqueta, ajusta según sea necesario
		label.add_theme_color_override("font_color", Color(0, 0, 0))
		add_child(label)
		labels.append(label)

	queue_redraw()
	
	# Emitir la señal divisiones_actualizadas después de crear las divisiones
	emit_signal("divisiones_actualizadas", divisions)
	
func percentage_to_fraction(percentage):
	if percentage == 100:
		return "1"
		
	var numerator = percentage
	var denominator = 100
	
	# Encontrar el máximo común divisor (MCD)
	var divisor = gcd(numerator, denominator)
	numerator /= divisor
	denominator /= divisor
	
	return str(numerator) + "/" + str(denominator)

func gcd(a, b):
	while b != 0:
		var t = b
		b = a % b
		a = t
	return a

func update_labels():
	if porcentajes1.size() == 0 or labels.size() == 0:
		return

	var pizza_center = Vector2(0, 0)  # Centro de la pizza, ajusta según tu sprite
	var pizza_radius = 160  # Radio de la pizza, ajusta según tu sprite

	# Actualizar la posición y texto de cada Label
	var last_angle = 0
	for i in range(porcentajes1.size()):
		var angle = divisions[i]
		var radians_start = deg_to_rad(last_angle)
		var radians_end = deg_to_rad(angle)
		var sector_angle = radians_end - radians_start
		var middle_angle = radians_start + sector_angle / 2
		var middle_point = pizza_center + Vector2(cos(middle_angle), sin(middle_angle)) * (pizza_radius / 2)

		# Obtener tamaño real de la etiqueta
		var label_size = labels[i].get_combined_minimum_size()

		# Establecer la posición de la etiqueta
		labels[i].position = middle_point - label_size / 4.5  # Centrar la etiqueta sobre la posición

		last_angle = angle

	# Ocultar Labels no utilizados
	for i in range(porcentajes1.size(), labels.size()):
		labels[i].visible = false

func _draw():
	if divisions.size() == 0:
		return

	var pizza_center = Vector2(0, 0)  # Centro de la pizza, ajusta según tu sprite
	var pizza_radius = 160  # Radio de la pizza, ajusta según tu sprite

	# Dibuja las líneas de división
	var last_angle = 0
	for angle in divisions:
		var radians_start = deg_to_rad(last_angle)
		var radians_end = deg_to_rad(angle)
		var end_point_start = pizza_center + Vector2(cos(radians_start), sin(radians_start)) * pizza_radius
		var end_point_end = pizza_center + Vector2(cos(radians_end), sin(radians_end)) * pizza_radius
		
		# Dibuja las líneas que representan las divisiones
		draw_line(pizza_center, end_point_start, Color(0, 0, 0), 2)  # Línea de división al inicio
		draw_line(pizza_center, end_point_end, Color(0, 0, 0), 2)  # Línea de división al final

		last_angle = angle  # Actualiza el ángulo de inicio para la próxima división

	# Opcional: Dibujar línea adicional para completar la última división
	draw_line(pizza_center, pizza_center + Vector2(cos(deg_to_rad(last_angle)), sin(deg_to_rad(last_angle))) * pizza_radius, Color(0, 0, 0), 2)

func colocar_ingrediente(ingrediente, posicion):
	ingredientes_colocados.append({"ingrediente": ingrediente, "posicion": posicion})

func verificar_pizza():
	var ingredientes_por_posicion = {}
	for item in ingredientes_colocados:
		var posicion = item["posicion"]
		var ingrediente = item["ingrediente"]
		var angulo = calcular_angulo(pizza_divisions, posicion)
		if not ingredientes_por_posicion.has(angulo):
			ingredientes_por_posicion[angulo] = []
		ingredientes_por_posicion[angulo].append(ingrediente)

	var orden_correcta = true
	for i in range(orden_actual["ingredientes"].size()):
		var ingrediente_orden = orden_actual["ingredientes"][i]
		var porcentaje_orden = orden_actual["porcentajes"][i]
		var angulo_orden = porcentaje_a_angulo(porcentaje_orden)

		if not ingredientes_por_posicion.has(angulo_orden) or not ingrediente_orden in ingredientes_por_posicion[angulo_orden]:
			orden_correcta = false
			break

	if orden_correcta:
		print("¡La pizza está correcta!")
	else:
		print("¡La pizza no está correcta!")

func calcular_angulo(divisions, posicion):
	# Calcular el ángulo de la porción dada una posición (esto depende de tu implementación específica)
	# Suponemos que `posicion` es un índice que corresponde a `divisions`
	if posicion >= 0 and posicion < divisions.size():
		return divisions[posicion]
	return -1

func porcentaje_a_angulo(porcentaje):
	# Convertir porcentaje a ángulo en grados
	return porcentaje * 3.6

func _on_timbre_evaluar_timbre():
	verificar_pizza()
	var orden_pizza_node = get_node("../../nodo_control")
	if orden_pizza_node != null:
		orden_pizza_node.generarNuevaOrden()
