# PizzaSlice.gd
extends Area2D

# Propiedad personalizada para almacenar el índice de la porción
var ingrediente : String
var slice_index : int

func _ready():
	# Inicialización adicional si es necesario
	pass

# Función para configurar la área de colisión
func setup_collision_area(points):
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = points
	add_child(collision_shape)


func get_ingrediente():
	return ingrediente


func _on_area_entered(area):
	if area.has_method("get_ingredient"):
		var ingrediente_entrante = area.get_ingredient()
		if ingrediente_entrante == ingrediente:
			print("Ingrediente correcto", ingrediente_entrante, "ha entrado en el área")
		else:
			print("Ingrediente incorrecto", ingrediente_entrante, "ha entrado en el área")
