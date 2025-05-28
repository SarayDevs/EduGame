extends Node2D

const NUM_SLICES = 8  # Número de porciones
const PIZZA_RADIUS = 100  # Radio de la pizza

func _ready():
	# Crear y añadir el Sprite de la pizza
	var pizza_sprite = Sprite2D.new()
	pizza_sprite.texture = load("res://path_to_pizza_texture.png")
	add_child(pizza_sprite)
	
	for i in range(NUM_SLICES):
		var slice_points = calculate_slice_points(i, NUM_SLICES, PIZZA_RADIUS)
		var slice = create_pizza_slice(slice_points)
		slice.slice_index = i  # Asignar el índice de la porción
		add_child(slice)
		
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = slice_points
		slice.add_child(collision_polygon)
		

func calculate_slice_points(slice_index, total_slices, radius):
	var angle_per_slice = 2 * PI / total_slices
	var start_angle = slice_index * angle_per_slice
	var end_angle = start_angle + angle_per_slice
	
	var points = [
		Vector2(0, 0),  # Centro de la pizza
		Vector2(cos(start_angle) * radius, sin(start_angle) * radius),
		Vector2(cos(end_angle) * radius, sin(end_angle) * radius)
	]
	
	return points

func create_pizza_slice(points):
	var slice = load("res://PizzaSlice.gd").new()
	slice.polygon = points
	slice.color = Color(1, 1, 1, 0.5)  # Color y transparencia de la porción
	return slice

func _on_slice_area_entered(area):
	var collision_polygon = area as CollisionPolygon2D
	if collision_polygon:
		var slice = collision_polygon.get_parent() as Polygon2D
		if slice and slice.has_method("get_slice_index"):
			var slice_index = slice.slice_index
			print("Algo entró en la porción: ", slice_index, " - ", area.name)
