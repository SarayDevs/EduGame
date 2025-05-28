extends Area2D

var ingredient
var mouseClick = false
var posicion_inicial3: Vector2
signal ingrediente

@export var ingredientes7_scene: PackedScene


func _ready():
	posicion_inicial3 = position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if mouseClick:
				print("Haciendo clic dentro del área")
				elegir_ingredien()

func elegir_ingredien():
	var piña = ingredientes7_scene.instantiate()
	piña.position = get_global_mouse_position()
	
	# Ajustar el z_index para que esté sobre todos los demás nodos
	piña.z_index = get_parent().get_child_count()  # Establecer el z_index al final del árbol
	
	get_parent().add_child(piña)
	print("Ingrediente piña instanciado y añadido a la escena")



func _on_mouse_entered():
	mouseClick = true

func _on_mouse_exited():
	mouseClick = false
