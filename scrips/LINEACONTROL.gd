extends Node2D

signal divisiones_actualizadas(divisions) 
var orden_correcta = null
var orden_actual = {
	"ingredientes": [],
	"porcentajes": []
}

var ingredientes_colocados = []
var pizza_divisions = []
var divisions = []
var ingredient_textures = []
var porcentajes1 = []
var labels = []
var areas = []
var porciones_correctas = []

const PIZZA_RADIUS = 160

func _ready():
	var orden_pizza_node = get_node("../nodo_control")
	if orden_pizza_node:
		print("Nodo de orden de pizza encontrado")
	else:
		print("Error: Nodo de orden de pizza no encontrado.")

func _on_nodo_control_orden_actualizada(porcentajes, ingredientes_orden):
	orden_actual["ingredientes"] = ingredientes_orden
	orden_actual["porcentajes"] = porcentajes
	print("Orden actualizada:", orden_actual)
	porcentajes1 = porcentajes
	porciones_correctas.resize(porcentajes.size())  # Redimensionar el array para que tenga el tamaño adecuado
	for i in range(porcentajes.size()):
		porciones_correctas[i] = false  # Inicializar cada elemento como false
	create_divisions(porcentajes, ingredientes_orden)
	update_labels()

func _on_divisiones_actualizadas(divisions):
	pizza_divisions = divisions

func create_divisions(porcentajes, ingredientes_orden):
	divisions.clear()
	ingredient_textures.clear()

	for label in labels:
		label.queue_free()
	labels.clear()

	for area in areas:
		area.queue_free()
	areas.clear()

	if porcentajes.size() == 1 and porcentajes[0] == 100:
		# Crear una sola porción que ocupe toda la pizza
		var area = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = PIZZA_RADIUS
		collision_shape.shape = circle_shape
		area.add_child(collision_shape)
		area.name = ingredientes_orden[0]
		area.add_to_group(ingredientes_orden[0])  # Asignar grupo según el ingrediente
		area.monitorable = false
		area.collision_layer = 1
		area.collision_mask = 1
		add_child(area)
		areas.append(area)
		 # Termina la función aquí para evitar el dibujo de líneas

	var total_angle = 0

	for i in range(porcentajes.size()):
		var porcentaje = porcentajes[i]
		var angle = porcentaje * 3.6
		var start_angle = total_angle
		total_angle += angle
		divisions.append(total_angle)

		var label = Label.new()
		label.text = percentage_to_fraction(porcentaje)
		label.set_custom_minimum_size(Vector2(100, 100))
		label.add_theme_color_override("font_color", Color(0, 0, 0))
		add_child(label)
		labels.append(label)

		var area = Area2D.new()
		var ingrediente = ingredientes_orden[i]
		area.name = ingrediente
		area.add_to_group(ingrediente)  # Asignar grupo según el ingrediente
		area.monitorable = false
		area.collision_layer = 1 << i  # Asignar una capa única para cada porción
		area.collision_mask = 1 << i  # Solo detectar colisiones en su propia capa
		
		print("Porción", i, "con ingrediente", ingrediente, "tiene capa de colisión:", area.collision_layer, "y máscara de colisión:", area.collision_mask)

		var collision_shape = CollisionPolygon2D.new()
		var points = []

		points.append(Vector2(0, 0))
		for j in range(start_angle, total_angle + 1, 1):
			var rad = deg_to_rad(j)
			points.append(Vector2(cos(rad) * PIZZA_RADIUS, sin(rad) * PIZZA_RADIUS))
		points.append(Vector2(0, 0))

		collision_shape.polygon = points
		area.add_child(collision_shape)

		area.connect("area_entered", Callable(self, "_on_area_2d_area_entered"))

		add_child(area)
		areas.append(area)
		
		area.set_meta("index", i)  # Asegurarse de que el índice se establezca aquí
		print("Área creada con índice:", i)
		
	queue_redraw()
	emit_signal("divisiones_actualizadas", divisions)

func percentage_to_fraction(percentage):
	if percentage == 100:
		return "1"
	
	var numerator = percentage
	var denominator = 100
	
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
	if divisions.size() == 1 and divisions[0] == 360:
		return

	var pizza_center = Vector2(0, 0)  # Centro de la pizza, ajusta según tu sprite
	var pizza_radius = 160  # Radio de la pizza, ajusta según tu sprite

	# Dibuja las líneas de división
	var last_angle = 0
	for i in range(divisions.size()):
		var angle = divisions[i]
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

func calcular_angulo(divisions, posicion):
	if posicion >= 0 and posicion < divisions.size():
		return divisions[posicion]
	return -1

func porcentaje_a_angulo(porcentaje):
	return porcentaje * 3.6

func _on_area_2d_area_entered(area):
	var grupos = area.get_groups()
	var ingrediente_detectado = false
	for grupo in grupos:
		if grupo in orden_actual["ingredientes"]:
			var grupo_ingrediente = area.name
			print("Ingrediente", grupo_ingrediente, "ha entrado en el área")
			print("Nombre del área:", area.name)
			print("Pertenece al grupo:", grupo)

			area.set_deferred("monitorable", true)

			var indice_area = area.get_meta("index")
			if indice_area == null:  # Verificar si el índice es nulo
				indice_area = 0  # Asignar 0 si es nulo
				area.set_meta("index", indice_area)
				print("Índice nulo detectado, asignando índice 0")

			print("Área de colisión ingresada: ", area, "con nombre: ", area.name, "y índice: ", indice_area)
			print (grupo)
			
			# Asegurarse de que el índice esté dentro de las porciones de la pizza
			if indice_area < divisions.size():  # Cambiar 'porciones' por 'divisions'
				if grupo in orden_actual["ingredientes"]:
					ingredientes_colocados.append([area, grupo_ingrediente])
					print("Ingrediente correcto colocado en porción ", indice_area, " con ingrediente: ", grupo_ingrediente)
					porciones_correctas[indice_area] = true  # Marcar la porción como correcta
				else:
					print("Ingrediente incorrecto colocado en la porción ", indice_area, "con ingrediente: ", grupo_ingrediente)
				ingrediente_detectado = true
				# Evaluar si el ingrediente sale de la porción y marcar la porción como incorrecta
				verificar_ingrediente_en_porcion(area, indice_area)
			else:
				print("El índice del área ", indice_area, " está fuera del rango de las porciones.")
			break
	if not ingrediente_detectado:
		print("No se encontró el ingrediente en los grupos asignados.")
		
func verificar_ingrediente_en_porcion(area, indice_area):
	# Usar un temporizador para realizar la verificación después de un breve periodo
	await get_tree().create_timer(0.1).timeout

	# Verificar si el área sigue colisionando con la porción correcta
	var sigue_en_porcion_correcta = false
	for child_area in areas:
		if child_area.get_meta("index") == indice_area:
			if child_area.get_overlapping_areas().has(area):
				sigue_en_porcion_correcta = true
				break

	if not sigue_en_porcion_correcta:
		porciones_correctas[indice_area] = false  # Marcar como incorrecta
		print("Ingrediente", area.name, "ya no está en la porción correcta", indice_area, ", marcando como incorrecta")

func verificar_pizza():
	var todas_correctas = true
	for i in range(porciones_correctas.size()):
		if porciones_correctas[i]:
			print("Porción", i, "es correcta")
		else:
			print("Porción", i, "es incorrecta")
			todas_correctas = false
	
	if porciones_correctas.size() > 0 and todas_correctas:
		print("Todas las porciones son correctas")
		$"..".subirScore()
	else:
		print("Hay porciones incorrectas")
		$"..".lose_star()

func _on_timbre_evaluar_timbre():
	verificar_pizza()
	var orden_pizza_node = get_node("../nodo_control")
	if orden_pizza_node != null:
		orden_pizza_node.generarNuevaOrden()
