extends Node2D

# Variable para almacenar la plantilla del área
var area_template

# Nodo para el área especial
@onready var special_area = $SpecialArea

func _ready():
	# Cargar la plantilla del área
	area_template = $Area2D
	# Ocultar la plantilla original
	area_template.hide()
	
	# Generar áreas y colisiones aleatorias
	for i in range(10):
		create_random_area()
	# Configurar el área especial
	setup_special_area()

func create_random_area():
	# Instanciar un nuevo Area2D a partir de la plantilla
	var new_area = area_template.duplicate()
	new_area.show()

	# Crear una nueva colisión aleatoria
	var new_collision_polygon = generate_random_polygon()
	new_area.get_node("CollisionPolygon2D").polygon = new_collision_polygon
	
	# Posicionar el área en una posición aleatoria
	new_area.position = Vector2(randi() % 1024, randi() % 768)
	
	# Conectar la señal de área entrante al nuevo área
	new_area.connect("area_entered", Callable(self, "_on_area_entered"))
	
	# Añadir el nuevo área como hijo del nodo root
	add_child(new_area)

func generate_random_polygon():
	var points = PackedVector2Array()
	
	# Generar puntos aleatorios para el polígono
	for i in range(3 + randi() % 5):
		var point = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		points.append(point)
	
	return points

func _on_area_2d_area_entered(area):
	print("Un cuerpo ha entrado en el área:", area.name)
	

func setup_special_area():
	# Configurar el polígono de colisión para el área especial
	var special_polygon = generate_random_polygon()
	special_area.get_node("CollisionPolygon2D").polygon = special_polygon
	
	# Configurar el color del área especial
	special_area.get_node("CollisionPolygon2D").set("color", Color(0, 1, 0, 0.5)) # Verde
	
	# Conectar la señal de área entrante al área especial usando Callable
	special_area.connect("area_entered", Callable(self, "_on_special_area_entered"))
	
	# Posicionar el área especial en una posición aleatoria
	special_area.position = Vector2(randi() % 1024, randi() % 768)

# Función que se ejecuta cuando un cuerpo entra en el área especial
func _on_special_area_entered(area):
	if area.name == "albahaca" and area.is_in_group("albahaca"):
		print("correcto")
	else:
		print("incorrecto")


func _on_special_area_area_entered(area):
	pass # Replace with function body.
