extends Area2D

var ingredient
var mouseClick = null
signal ingrediente

@export var ingredientes1_scene: PackedScene
@export var ingredientes2_scene: PackedScene
@export var ingredientes3_scene: PackedScene
@export var ingredientes4_scene: PackedScene
@export var ingredientes5_scene: PackedScene
@export var ingredientes6_scene: PackedScene
@export var ingredientes7_scene: PackedScene
@export var ingredientes8_scene: PackedScene
@export var ingredientes9_scene: PackedScene

var ingredientes_instanciados: Array = []

func _ready():
	# No se necesita conectar ninguna señal adicional
	pass

func _input(event):
	if mouseClick and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_in_group("albahaca"):
			ingredient = "albahaca"
		elif is_in_group("anchoa"):
			ingredient = "anchoa"
		elif is_in_group("champiñon"):
			ingredient = "champiñon"
		elif is_in_group("aceituna"):
			ingredient = "aceituna"
		elif is_in_group("cebollin"):
			ingredient = "cebollin"
		elif is_in_group("pimenton"):
			ingredient = "pimenton"
		elif is_in_group("piña"):
			ingredient = "piña"
		elif is_in_group("peperoni"):
			ingredient = "peperoni"
		elif is_in_group("queso"):
			ingredient = "queso"
		else:
			print("No se encontró ingrediente")
		
		if ingredient:
			print("Ingrediente elegido:", ingredient)
			print("Ubicación del objeto al spawnear:", global_transform.origin)
			elegir_ingredien()

func elegir_ingredien():
	match ingredient:
		"albahaca":
			add_ingredient(ingredientes1_scene)
		"anchoa":
			add_ingredient(ingredientes2_scene)
		"champiñon":
			add_ingredient(ingredientes3_scene)
		"aceituna":
			add_ingredient(ingredientes4_scene)
		"cebollin":
			add_ingredient(ingredientes5_scene)
		"pimenton":
			add_ingredient(ingredientes6_scene)
		"piña":
			add_ingredient(ingredientes7_scene)
		"peperoni":
			add_ingredient(ingredientes8_scene)
		"queso":
			add_ingredient(ingredientes9_scene)

func add_ingredient(scene: PackedScene):
	if scene:
		var ingredient_instance = scene.instantiate()
		ingredient_instance.position = get_global_mouse_position()
		ingredient_instance.add_to_group(ingredient)
		ingredient_instance.name = ingredient  # Asignar el nombre del grupo al nombre del ingrediente

		# Buscar la porción correspondiente y asignar propiedades
		var group = ingredient
		var division_node = get_node("../division2")
		for area in division_node.get_children():
			if area is Area2D and area.is_in_group(group):
				var indice = area.get_meta("index")
				if indice is int and indice >= 0:
					ingredient_instance.set_meta("index", indice)
					# Asignar las propiedades de colisión desde el área
					ingredient_instance.collision_layer = area.collision_layer
					ingredient_instance.collision_mask = area.collision_mask
					
					print("Asignado a ingrediente", ingredient, "con capa de colisión:", ingredient_instance.collision_layer, "y máscara de colisión:", ingredient_instance.collision_mask)
					break
				else:
					print("No se encontró un índice válido para el ingrediente, se mantendrá como null")
					ingredient_instance.set_meta("index", null)  # Mantener índice como null si no coincide
		
		call_deferred("add_child_deferred", ingredient_instance)
		ingredientes_instanciados.append(ingredient_instance)
		print("Ingrediente instanciado y añadido a la escena:", ingredient_instance.name, "con índice:", ingredient_instance.get_meta("index"))
	else:
		print("Error: ingredient_scene no está asignado.")

func add_child_deferred(node):
	get_parent().add_child(node)

func _on_mouse_entered():
	mouseClick = true

func _on_mouse_exited():
	mouseClick = false

func reset_ingredients():
	for ingredient_instance in ingredientes_instanciados:
		ingredient_instance.queue_free()
	ingredientes_instanciados.clear()

func _on_timbre_evaluar_timbre():
	reset_ingredients()
